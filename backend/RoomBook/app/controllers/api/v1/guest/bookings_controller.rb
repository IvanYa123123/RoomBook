module Api
  module V1
    module Guest
      class BookingsController < BaseController
        before_action :require_guest!

        def index
          # :review нужен для BookingSerializer#reviewable? (иначе N+1)
          scope = current_user.bookings
                              .includes(:review, room: [{ photos_attachments: :blob }, :hotel])
                              .order(check_in: :desc)

          scope = case params[:status]
                  when "upcoming"  then scope.where(status: :confirmed).where("check_in >= ?", Date.current)
                  when "completed" then scope.where(status: :confirmed).where("check_out < ?", Date.current)
                  when "cancelled" then scope.where(status: :cancelled)
                  when "pending"   then scope.where(status: :pending)
                  else scope
                  end

          render json: { bookings: scope.map { |b| BookingSerializer.call(b, request) } }
        end

        def cancel
          booking = current_user.bookings.find(params[:id])

          if booking.pending?
            booking.update(status: :cancelled)
            render json: { booking: BookingSerializer.call(booking, request) }
          else
            render json: { error: "Отменить можно только заявку в ожидании" },
                   status: :unprocessable_entity
          end
        end
      end
    end
  end
end
