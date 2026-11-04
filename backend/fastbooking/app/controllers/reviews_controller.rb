class ReviewsController < ApplicationController
  before_action :require_guest

  def create
    @hotel = Hotel.find(params[:hotel_id])
    booking = eligible_booking

    if booking.nil?
      redirect_to @hotel, alert: "Отзыв можно оставить только после завершённого проживания"
      return
    end

    review = current_user.reviews.new(review_params.merge(hotel: @hotel, booking: booking))

    if review.save
      redirect_to @hotel, notice: "Спасибо за отзыв!"
    else
      redirect_to @hotel, alert: review.errors.full_messages.to_sentence
    end
  end

  private

  def eligible_booking
    current_user.bookings
                .joins(:room)
                .where(rooms: { hotel_id: @hotel.id }, status: :confirmed)
                .where("bookings.check_out < ?", Date.current)
                .where.missing(:review)
                .first
  end

  def review_params
    params.require(:review).permit(:rating, :body)
  end
end
