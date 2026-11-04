require "test_helper"

class AuthenticationTest < ActionDispatch::IntegrationTest
  test "anonymous can browse" do
    get root_path
    assert_response :success
    get hotels_path
    assert_response :success
    get hotel_path(hotels(:sea_hotel))
    assert_response :success
  end

  test "guest signs up" do
    assert_difference("User.count", 1) do
      post signup_path, params: {
        user: {
          email: "newguest@example.com", first_name: "Новый",
          password: "password123", password_confirmation: "password123", role: "guest"
        }
      }
    end
    assert_redirected_to guest_bookings_path
  end

  test "host signs up" do
    assert_difference("User.count", 1) do
      post signup_path, params: {
        user: {
          email: "newhost@example.com", first_name: "Новый",
          password: "password123", password_confirmation: "password123", role: "host"
        }
      }
    end
    assert_redirected_to host_hotels_path
  end

  test "login with wrong password" do
    post login_path, params: { email: users(:guest_user).email, password: "wrong" }
    assert_response :unprocessable_entity
  end

  test "login and logout" do
    post login_path, params: { email: users(:guest_user).email, password: "password123" }
    assert_redirected_to guest_bookings_path

    delete logout_path
    assert_redirected_to root_path
  end
end
