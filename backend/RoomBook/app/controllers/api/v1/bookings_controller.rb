module Api
  module V1
    class BookingsController < BaseController
      before_action :require_guest!

      def create
        hotel = Hotel.find(params[:hotel_id])
        room_id = param_any(:room_id, :roomId)

        return render(json: { error: "Не указан номер" }, status: :bad_request) if room_id.blank?

        room = hotel.rooms.find(room_id)

        booking = nil
        # Блокировка строки номера сериализует одновременные попытки
        # забронировать один и тот же номер на пересекающиеся даты.
        room.with_lock do
          booking = current_user.bookings.new(
            room: room,
            check_in: parse_date(param_any(:check_in, :checkIn)),
            check_out: parse_date(param_any(:check_out, :checkOut)),
            # Явный nil из params не должен затирать default=1
            guests_count: param_any(:guests_count, :guestsCount) || 1
          )
          booking.save
        end

        if booking.persisted?
          render json: { booking: BookingSerializer.call(booking, request) }, status: :created
        else
          render_errors(booking)
        end
      rescue ActiveRecord::StatementInvalid => e
        # Страховка от гонки на уровне БД: exclusion constraint bookings_no_overlap
        if e.message.include?("bookings_no_overlap")
          render json: { errors: ["Номер уже забронирован на выбранные даты"] },
                 status: :unprocessable_entity
        else
          raise
        end
      end
    end
  end
end
