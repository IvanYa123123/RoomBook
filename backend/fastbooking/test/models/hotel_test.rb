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

  test "with_price_between filters by minimum room price" do
    # sea_hotel has rooms at 3000 and 7000. city_hotel has room at 2000.
    
    # Range 4000..8000 -> only sea_hotel (min is 3000, which is < 4000, so it should NOT match)
    # Wait, the logic says: MIN(price_per_night) >= min_price AND MIN(price_per_night) <= max_price.
    # For sea_hotel: MIN is 3000. 3000 >= 4000 is false. So it should NOT match.
    assert_empty Hotel.with_price_between(4000, 8000)

    # Range 2000..5000 -> both sea_hotel (min 3000) and city_hotel (min 2000) match
    assert_includes Hotel.with_price_between(2000, 5000), hotels(:sea_hotel)
    assert_includes Hotel.with_price_between(2000, 5000), hotels(:city_hotel)

    # Range 3000..4000 -> only sea_hotel (min 3000)
    assert_includes Hotel.with_price_between(3000, 4000), hotels(:sea_hotel)
    assert_not_includes Hotel.with_price_between(3000, 4000), hotels(:city_hotel)
    
    # Range 1000..2500 -> only city_hotel
    assert_includes Hotel.with_price_between(1000, 2500), hotels(:city_hotel)
    assert_not_includes Hotel.with_price_between(1000, 2500), hotels(:sea_hotel)

    # Only min
    assert_includes Hotel.with_price_between(3000, nil), hotels(:sea_hotel)
    assert_not_includes Hotel.with_price_between(3000, nil), hotels(:city_hotel)

    # Only max
    assert_includes Hotel.with_price_between(nil, 3000), hotels(:sea_hotel)
    assert_includes Hotel.with_price_between(nil, 2000), hotels(:city_hotel)
    assert_not_includes Hotel.with_price_between(nil, 2000), hotels(:sea_hotel)

    # Both blank
    assert_equal Hotel.count, Hotel.with_price_between(nil, nil).count
  end
end
