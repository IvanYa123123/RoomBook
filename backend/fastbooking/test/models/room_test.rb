require "test_helper"

class RoomTest < ActiveSupport::TestCase
  test "valid fixture" do
    assert rooms(:standard_room).valid?
  end

  test "rejects zero or negative price" do
    room = Room.new(hotel: hotels(:sea_hotel), name: "Тест", capacity: 2, price_per_night: 0)
    assert_not room.valid?
  end

  test "rejects capacity out of range" do
    room = Room.new(hotel: hotels(:sea_hotel), name: "Тест", capacity: 11, price_per_night: 1000)
    assert_not room.valid?
  end

  test "availability check respects overlapping bookings" do
    room = rooms(:standard_room)
    assert_not room.available_between?(Date.current + 6, Date.current + 8)
    assert room.available_between?(Date.current + 30, Date.current + 32)
  end

  test "amenities list parses comma separated string" do
    assert_equal ["Wi-Fi", "Кондиционер"], rooms(:standard_room).amenities_list
  end
end
