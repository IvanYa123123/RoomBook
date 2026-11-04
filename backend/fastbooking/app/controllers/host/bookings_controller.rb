module Host
  class BookingsController < ApplicationController
    before_action :require_host

    def index
      @hotels = current_user.hotels.order(:name)
      @hotel_id = params[:hotel_id].presence

      scope = Booking.joins(room: :hotel)
                     .where(rooms: { hotel_id: current_user.hotels.select(:id) })
                     .includes(:user, room: :hotel)
                     .order(created_at: :desc)

      scope = scope.where(rooms: { hotel_id: @hotel_id }) if @hotel_id
      @bookings = scope.page(params[:page]).per(20)
    end

    def confirm
      booking = find_booking

      if booking.pending?
        booking.update(status: :confirmed)
        redirect_to host_bookings_path, notice: "Бронь №#{booking.id} подтверждена"
      else
        redirect_to host_bookings_path, alert: "Заявка уже обработана"
      end
    end

    def reject
      booking = find_booking

      if booking.pending?
        booking.update(status: :cancelled)
        redirect_to host_bookings_path, notice: "Бронь №#{booking.id} отклонена, даты освобождены"
      else
        redirect_to host_bookings_path, alert: "Заявка уже обработана"
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
