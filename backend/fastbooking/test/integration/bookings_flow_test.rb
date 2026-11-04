require "test_helper"

class BookingsFlowTest < ActionDispatch::IntegrationTest
  test "guest creates a booking request" do
    sign_in(users(:guest_user))
    room = rooms(:suite_room)

    assert_difference("Booking.count", 1) do
      post hotel_bookings_path(hotels(:sea_hotel), room_id: room.id), params: {
        booking: {
          check_in: Date.current + 50, check_out: Date.current + 53, guests_count: 2
        }
      }
    end
    booking = Booking.order(:created_at).last
    assert_redirected_to guest_bookings_path
    assert_equal "pending", booking.status
    assert_equal 21_000, booking.total_price.to_i
  end

  test "guest cannot book more guests than capacity" do
    sign_in(users(:guest_user))
    assert_no_difference("Booking.count") do
      post hotel_bookings_path(hotels(:sea_hotel), room_id: rooms(:standard_room).id), params: {
        booking: { check_in: Date.current + 60, check_out: Date.current + 62, guests_count: 8 }
      }
    end
    assert_response :unprocessable_entity
  end

  test "guest cancels pending booking" do
    sign_in(users(:guest_user))
    booking = bookings(:pending_booking)
    patch cancel_guest_booking_path(booking)
    assert_redirected_to guest_bookings_path
    assert_equal "cancelled", booking.reload.status
  end

  test "guest cannot cancel confirmed booking" do
    sign_in(users(:guest_user))
    booking = bookings(:confirmed_booking)
    patch cancel_guest_booking_path(booking)
    assert_equal "confirmed", booking.reload.status
  end

  test "host confirms pending booking" do
    sign_in(users(:host_user))
    booking = bookings(:pending_booking)
    patch confirm_host_booking_path(booking)
    assert_redirected_to host_bookings_path
    assert_equal "confirmed", booking.reload.status
  end

  test "host rejects pending booking and frees dates" do
    sign_in(users(:host_user))
    booking = bookings(:pending_booking)
    room = booking.room

    patch reject_host_booking_path(booking)
    assert_equal "cancelled", booking.reload.status
    assert room.reload.available_between?(booking.check_in, booking.check_out)
  end
end
