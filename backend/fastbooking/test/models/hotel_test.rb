require "test_helper"

class HotelTest < ActiveSupport::TestCase
  test "valid fixture" do
    assert hotels(:sea_hotel).valid?
  end

  test "requires name, city and address" do
    hotel = Hotel.new(user: users(:host_user))
    assert_not hotel.valid?
  end

  test "filters by city case-insensitively" do
    assert_includes Hotel.in_city("севастополь"), hotels(:sea_hotel)
    assert_not_includes Hotel.in_city("севастополь"), hotels(:city_hotel)
  end

  test "computes min price across rooms" do
    assert_equal 3000, hotels(:sea_hotel).min_price.to_i
  end

  test "average rating" do
    assert_equal 5.0, hotels(:city_hotel).average_rating
    assert_nil hotels(:sea_hotel).average_rating
  end
end
