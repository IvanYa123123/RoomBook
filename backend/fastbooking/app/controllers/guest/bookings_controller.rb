module Guest
  class BookingsController < ApplicationController
    before_action :require_guest

    def index
      @filter = params[:status].presence || "all"

      scope = current_user.bookings
                         .includes(room: { hotel: { photos_attachments: :blob } })
                         .order(check_in: :desc)

      @bookings = case @filter
                  when "upcoming"  then scope.where(status: :confirmed).where("check_in >= ?", Date.current)
                  when "completed" then scope.where(status: :confirmed).where("check_out < ?", Date.current)
                  when "cancelled" then scope.where(status: :cancelled)
                  when "pending"   then scope.where(status: :pending)
                  else scope
                  end
    end

    def cancel
      booking = current_user.bookings.find(params[:id])

      if booking.pending?
        booking.update(status: :cancelled)
        redirect_to guest_bookings_path, notice: "Бронирование отменено"
      else
        redirect_to guest_bookings_path, alert: "Отменить можно только заявку в ожидании подтверждения"
      end
    end
  end
end
