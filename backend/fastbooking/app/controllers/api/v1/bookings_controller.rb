module Api
  module V1
    class BookingsController < BaseController
      before_action :require_guest!

      def create
        hotel = Hotel.find(params[:hotel_id])
        room = hotel.rooms.find(params[:room_id])

        booking = current_user.bookings.new(
          room: room,
          check_in: params[:check_in],
          check_out: params[:check_out],
          guests_count: params[:guests_count]
        )

        if booking.save
          render json: { booking: serialize(booking) }, status: :created
        else
          render_errors(booking)
        end
      end

      private

      def serialize(booking)
        {
          id: booking.id,
          status: booking.status,
          check_in: booking.check_in,
          check_out: booking.check_out,
          guests_count: booking.guests_count,
          total_price: booking.total_price.to_f,
          nights: booking.nights
        }
      end
    end
  end
end
