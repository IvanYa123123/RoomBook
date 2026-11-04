require "test_helper"

class BookingTest < ActiveSupport::TestCase
  test "valid fixture" do
    assert bookings(:confirmed_booking).valid?
  end

  test "calculates total price on validation" do
    booking = Booking.new(
      user: users(:guest_user), room: rooms(:suite_room),
      check_in: Date.current + 30, check_out: Date.current + 33, guests_count: 2
    )
    booking.validate
    assert_equal 21_000, booking.total_price.to_i
    assert_equal 3, booking.nights
  end

  test "rejects check_out not after check_in" do
    booking = Booking.new(
      user: users(:guest_user), room: rooms(:suite_room),
      check_in: Date.current + 30, check_out: Date.current + 30, guests_count: 1
    )
    assert_not booking.valid?
  end

  test "rejects check_in in the past" do
    booking = Booking.new(
      user: users(:guest_user), room: rooms(:suite_room),
      check_in: Date.current - 2, check_out: Date.current + 1, guests_count: 1
    )
    assert_not booking.valid?
  end

  test "rejects guests exceeding room capacity" do
    booking = Booking.new(
      user: users(:guest_user), room: rooms(:standard_room),
      check_in: Date.current + 40, check_out: Date.current + 42, guests_count: 5
    )
    assert_not booking.valid?
  end

  test "rejects overlapping dates" do
    booking = Booking.new(
      user: users(:guest_user), room: rooms(:standard_room),
      check_in: Date.current + 6, check_out: Date.current + 8, guests_count: 1
    )
    assert_not booking.valid?
    assert_includes booking.errors[:base], "Номер уже забронирован на выбранные даты"
  end

  test "cancelled booking frees the dates" do
    bookings(:confirmed_booking).update!(status: :cancelled)
    booking = Booking.new(
      user: users(:guest_user), room: rooms(:standard_room),
      check_in: Date.current + 5, check_out: Date.current + 7, guests_count: 1
    )
    assert booking.valid?
  end

  test "completed scope only includes past confirmed bookings" do
    assert_includes Booking.completed, bookings(:completed_booking)
    assert_not_includes Booking.completed, bookings(:confirmed_booking)
  end
end
