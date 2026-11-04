require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  test "valid fixture" do
    assert reviews(:city_review).valid?
  end

  test "rejects rating outside 1..5" do
    review = Review.new(user: users(:guest_user), hotel: hotels(:city_hotel),
                        booking: bookings(:completed_booking), rating: 6)
    assert_not review.valid?
  end

  test "rejects review for unfinished booking" do
    review = Review.new(user: users(:guest_user), hotel: hotels(:sea_hotel),
                        booking: bookings(:confirmed_booking), rating: 5)
    assert_not review.valid?
  end

  test "rejects duplicate review for the same booking" do
    review = Review.new(user: users(:guest_user), hotel: hotels(:city_hotel),
                        booking: bookings(:completed_booking), rating: 4)
    assert_not review.valid?
  end
end
