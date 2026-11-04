require "test_helper"

class AuthorizationTest < ActionDispatch::IntegrationTest
  test "anonymous cannot open guest bookings" do
    get guest_bookings_path
    assert_redirected_to login_path
  end

  test "anonymous cannot open host area" do
    get host_hotels_path
    assert_redirected_to login_path
  end

  test "guest cannot open host area" do
    sign_in(users(:guest_user))
    get host_hotels_path
    assert_redirected_to root_path
  end

  test "host cannot open guest bookings" do
    sign_in(users(:host_user))
    get guest_bookings_path
    assert_redirected_to root_path
  end

  test "host cannot edit another host hotel" do
    sign_in(users(:host_user))
    get edit_host_hotel_path(hotels(:city_hotel))
    assert_response :not_found
  end

  test "host sees only own hotels" do
    sign_in(users(:host_user))
    get host_hotels_path
    assert_response :success
    assert_match(/Морской бриз/, response.body)
    assert_no_match(/Capital Inn/, response.body)
  end
end
