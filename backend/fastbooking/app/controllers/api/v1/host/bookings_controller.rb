module Api
  module V1
    module Host
      class BookingsController < BaseController
        before_action :require_host!

        def index
          hotel_id = param_any(:hotel_id, :hotelId)
          
          scope = Booking.joins(room: :hotel)
                         .where(rooms: { hotel_id: current_user.hotels.select(:id) })
                         .includes(:user, room: [{ photos_attachments: :blob }, :hotel])
                         .order(created_at: :desc)
          
          scope = scope.where(rooms: { hotel_id: hotel_id }) if hotel_id.present?

          render json: {
            bookings: scope.map { |b| BookingSerializer.call(b, request, with_user: true) },
            hotels: current_user.hotels.order(:name).map { |h| { id: h.id, name: h.name } }
          }
        end

        def confirm
          booking = find_booking
          if booking.pending?
            booking.update(status: :confirmed)
            render json: { booking: BookingSerializer.call(booking, request, with_user: true) }
          else
            render json: { error: "Заявка уже обработана" }, status: :unprocessable_entity
          end
        end

        def reject
          booking = find_booking
          if booking.pending?
            booking.update(status: :cancelled)
            render json: { booking: BookingSerializer.call(booking, request, with_user: true) }
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
      end
    end
  end
end
