class BookingsController < ApplicationController
  before_action :require_guest
  before_action :set_hotel

  def new
    @room = @hotel.rooms.find(params[:room_id])
    @booking = Booking.new(
      room: @room,
      guests_count: params[:guests].presence || 1,
      check_in: parse_date(params[:check_in]),
      check_out: parse_date(params[:check_out])
    )
  end

  def create
    @room = @hotel.rooms.find(params[:room_id])
    @booking = current_user.bookings.new(booking_params.merge(room: @room))

    if @booking.save
      redirect_to guest_bookings_path,
                  notice: "Заявка отправлена. Ожидает подтверждения владельцем."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_hotel
    @hotel = Hotel.find(params[:hotel_id])
  end

  def booking_params
    params.require(:booking).permit(:check_in, :check_out, :guests_count)
  end
end
