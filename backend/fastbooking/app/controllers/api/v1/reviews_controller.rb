module Api
  module V1
    class ReviewsController < BaseController
      before_action :require_guest!

      def create
        hotel = Hotel.find(params[:hotel_id])
        booking = eligible_booking(hotel)

        if booking.nil?
          return render json: { error: "Отзыв можно оставить только после завершённого проживания" },
                        status: :unprocessable_entity
        end

        review = current_user.reviews.new(
          hotel: hotel,
          booking: booking,
          rating: params[:rating],
          body: params[:body]
        )

        if review.save
          render json: { review: ReviewSerializer.call(review) }, status: :created
        else
          render_errors(review)
        end
      end

      private

      def eligible_booking(hotel)
        current_user.bookings
                    .joins(:room)
                    .where(rooms: { hotel_id: hotel.id }, status: :confirmed)
                    .where("bookings.check_out < ?", Date.current)
                    .where.missing(:review)
                    .first
      end
    end
  end
end
