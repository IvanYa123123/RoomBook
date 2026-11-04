require "test_helper"

class ApiTest < ActionDispatch::IntegrationTest
  test "POST /api/v1/signup with snake_case" do
    assert_difference("User.count", 1) do
      post api_v1_signup_path, params: {
        email: "newguest@example.com", first_name: "Новый",
        password: "password123", password_confirmation: "password123", role: "guest"
      }
    end
    assert_response :created
    json = JSON.parse(response.body)
    assert json["token"].present?
    assert_equal "Новый", json["user"]["firstName"]
    assert_equal "guest", json["user"]["role"]
  end

  test "POST /api/v1/signup with camelCase" do
    assert_difference("User.count", 1) do
      post api_v1_signup_path, params: {
        email: "newguest2@example.com", firstName: "Новый2",
        password: "password123", passwordConfirmation: "password123", role: "guest"
      }
    end
    assert_response :created
  end

  test "POST /api/v1/login returns token" do
    post api_v1_login_path, params: { email: users(:guest_user).email, password: "password123" }
    assert_response :success
    json = JSON.parse(response.body)
    assert json["token"].present?
    assert_equal users(:guest_user).first_name, json["user"]["firstName"]
  end

  test "GET /api/v1/hotels returns camelCase keys" do
    get api_v1_hotels_path, params: { city: "Севастополь" }
    assert_response :success
    json = JSON.parse(response.body)
    hotel = json["hotels"].first
    assert_not_nil hotel
    assert hotel.key?("imageUrl")
    assert hotel.key?("rating")
    assert hotel.key?("reviewsCount")
    assert hotel.key?("pricePerNight")
    assert_equal 1, json["meta"]["currentPage"]
  end

  test "GET /api/v1/hotels with destination alias" do
    get api_v1_hotels_path, params: { destination: "Севастополь" }
    assert_response :success
    assert_equal 1, JSON.parse(response.body)["hotels"].size
  end

  test "GET /api/v1/hotels/:id returns detail with rooms and reviews" do
    get api_v1_hotel_path(hotels(:city_hotel))
    assert_response :success
    json = JSON.parse(response.body)
    assert json.key?("rooms")
    assert json.key?("reviews")
    assert json["rooms"].first.key?("pricePerNight")
    assert json["reviews"].first.key?("authorName")
  end

  test "POST /api/v1/bookings creates booking with camelCase" do
    user = users(:guest_user)
    headers = auth_headers(user)
    room = rooms(:suite_room)
    hotel = room.hotel

    assert_difference("Booking.count", 1) do
      post api_v1_hotel_bookings_path(hotel), 
           headers: headers,
           params: { roomId: room.id, checkIn: Date.current + 50, checkOut: Date.current + 53, guestsCount: 2 }
    end

    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "pending", json["booking"]["status"]
    assert json["booking"].key?("completed")
    assert json["booking"].key?("reviewable")
    assert json["booking"]["room"].key?("photoUrl")
  end

  test "GET /api/v1/guest/bookings returns bookings" do
    user = users(:guest_user)
    headers = auth_headers(user)
    get api_v1_guest_bookings_path, headers: headers
    assert_response :success
    json = JSON.parse(response.body)
    assert json["bookings"].is_a?(Array)
    if json["bookings"].any?
      assert json["bookings"].first.key?("completed")
    end
  end

  test "PATCH /api/v1/guest/bookings/:id/cancel cancels booking" do
    user = users(:guest_user)
    headers = auth_headers(user)
    booking = bookings(:pending_booking)

    patch cancel_api_v1_guest_booking_path(booking), headers: headers
    assert_response :success
    assert_equal "cancelled", JSON.parse(response.body)["booking"]["status"]
  end

  test "POST review with invalid booking returns 422" do
    user = users(:guest_user)
    headers = auth_headers(user)
    hotel = hotels(:sea_hotel)

    post api_v1_hotel_reviews_path(hotel), 
         headers: headers,
         params: { rating: 5, body: "Класс" }

    assert_response :unprocessable_entity
    assert JSON.parse(response.body).key?("error")
  end

  test "GET missing hotel returns 404" do
    get api_v1_hotel_path(999999)
    assert_response :not_found
    assert_equal "Не найдено", JSON.parse(response.body)["error"]
  end

  test "POST booking without token returns 401" do
    hotel = hotels(:sea_hotel)
    post api_v1_hotel_bookings_path(hotel), params: { roomId: 1 }
    assert_response :unauthorized
  end
end
