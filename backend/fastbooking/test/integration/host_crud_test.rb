require "test_helper"

class HostCrudTest < ActionDispatch::IntegrationTest
  setup { sign_in(users(:host_user)) }

  test "host creates a hotel" do
    assert_difference("Hotel.count", 1) do
      post host_hotels_path, params: {
        hotel: { name: "Новый отель", city: "Сочи", address: "ул. Морская, 1", description: "Тест" }
      }
    end
    assert_redirected_to host_hotels_path
  end

  test "host cannot create invalid hotel" do
    assert_no_difference("Hotel.count") do
      post host_hotels_path, params: { hotel: { name: "", city: "", address: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "host updates own hotel" do
    hotel = hotels(:sea_hotel)
    patch host_hotel_path(hotel), params: { hotel: { name: "Морской бриз 2" } }
    assert_redirected_to host_hotels_path
    assert_equal "Морской бриз 2", hotel.reload.name
  end

  test "host creates a room" do
    hotel = hotels(:sea_hotel)
    assert_difference("Room.count", 1) do
      post host_hotel_rooms_path(hotel), params: {
        room: { name: "Эконом", capacity: 2, price_per_night: 1500, amenities: "Wi-Fi" }
      }
    end
    assert_redirected_to host_hotel_rooms_path(hotel)
  end

  test "host cannot delete room with active future bookings" do
    room = rooms(:standard_room)
    assert_no_difference("Room.count") do
      delete host_hotel_room_path(hotels(:sea_hotel), room)
    end
    assert_redirected_to host_hotel_rooms_path(hotels(:sea_hotel))
  end

  test "host deletes own hotel" do
    hotel = hotels(:sea_hotel)
    assert_difference("Hotel.count", -1) do
      delete host_hotel_path(hotel)
    end
  end
end
