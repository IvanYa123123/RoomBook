module Api
  module V1
    module Host
      class BookingsController < BaseController
        before_action :require_host!

        def index
          scope = Booking.joins(room: :hotel)
                         .where(rooms: { hotel_id: current_user.hotels.select(:id) })
                         .includes(:user, room: :hotel)
                         .order(created_at: :desc)
          scope = scope.where(rooms: { hotel_id: params[:hotel_id] }) if params[:hotel_id].present?

          render json: {
            bookings: scope.map { |b| serialize(b) },
            hotels: current_user.hotels.order(:name).map { |h| { id: h.id, name: h.name } }
          }
        end

        def confirm
          booking = find_booking
          if booking.pending?
            booking.update(status: :confirmed)
            render json: { booking: serialize(booking) }
          else
            render json: { error: "Заявка уже обработана" }, status: :unprocessable_entity
          end
        end

        def reject
          booking = find_booking
          if booking.pending?
            booking.update(status: :cancelled)
            render json: { booking: serialize(booking) }
          else
            render json: { error: "Заявка уже обработана" }, status: :unprocessable_entity
          end
        end

        private

        def find_booking
          Booking.joins(room: :hotel)
                 .where(rooms: { hotel_id: current_user.hotels.select(:id) })
                 .find(params[:id])
        end

        def serialize(booking)
          {
            id: booking.id,
            status: booking.status,
            status_label: status_label(booking),
            check_in: booking.check_in,
            check_out: booking.check_out,
            nights: booking.nights,
            guests_count: booking.guests_count,
            total_price: booking.total_price.to_f,
            created_at: booking.created_at.iso8601,
            room: { id: booking.room.id, name: booking.room.name },
            hotel: { id: booking.room.hotel.id, name: booking.room.hotel.name },
            user: {
              id: booking.user.id,
              full_name: booking.user.full_name,
              email: booking.user.email,
              first_name: booking.user.first_name
            }
          }
        end

        def status_label(booking)
          if booking.pending? then "Ожидает подтверждения"
          elsif booking.cancelled? then "Отклонено"
          elsif booking.completed? then "Завершено"
          else "Подтверждено"
          end
        end
      end
    end
  end
end
