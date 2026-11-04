module Api
  module V1
    module Guest
      class BookingsController < BaseController
        before_action :require_guest!

        def index
          scope = current_user.bookings
                              .includes(room: { hotel: { photos_attachments: :blob } })
                              .order(check_in: :desc)

          scope = case params[:status]
                  when "upcoming"  then scope.where(status: :confirmed).where("check_in >= ?", Date.current)
                  when "completed" then scope.where(status: :confirmed).where("check_out < ?", Date.current)
                  when "cancelled" then scope.where(status: :cancelled)
                  when "pending"   then scope.where(status: :pending)
                  else scope
                  end

          render json: { bookings: scope.map { |b| serialize(b) } }
        end

        def cancel
          booking = current_user.bookings.find(params[:id])

          if booking.pending?
            booking.update(status: :cancelled)
            render json: { booking: serialize(booking) }
          else
            render json: { error: "Отменить можно только заявку в ожидании" },
                   status: :unprocessable_entity
          end
        end

        private

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
            completed: booking.completed?,
            reviewable: booking.reviewable?,
            created_at: booking.created_at.iso8601,
            room: {
              id: booking.room.id,
              name: booking.room.name,
              photo: photo_url(booking.room)
            },
            hotel: {
              id: booking.room.hotel.id,
              name: booking.room.hotel.name,
              city: booking.room.hotel.city,
              address: booking.room.hotel.address
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
