module Api
  module V1
    class BookingsController < BaseController
      before_action :require_guest!

      def create
        hotel = Hotel.find(params[:hotel_id])
        room_id = param_any(:room_id, :roomId)
        room = hotel.rooms.find(room_id)

        booking = current_user.bookings.new(
          room: room,
          check_in: parse_date(param_any(:check_in, :checkIn)),
          check_out: parse_date(param_any(:check_out, :checkOut)),
          guests_count: param_any(:guests_count, :guestsCount)
        )

        if booking.save
          render json: { booking: BookingSerializer.call(booking, request) }, status: :created
        else
          render_errors(booking)
        end
      end
    end
  end
end
