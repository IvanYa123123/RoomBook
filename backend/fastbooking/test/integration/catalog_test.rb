require "test_helper"

class CatalogTest < ActionDispatch::IntegrationTest
  test "filters hotels by city" do
    get hotels_path, params: { city: "Севастополь" }
    assert_response :success
    assert_match(/Морской бриз/, response.body)
    assert_no_match(/Capital Inn/, response.body)
  end

  test "filters hotels by price range" do
    get hotels_path, params: { min_price: 5000, max_price: 10000 }
    assert_response :success
    assert_match(/Морской бриз/, response.body)
    assert_no_match(/Capital Inn/, response.body)
  end

  test "shows empty state when nothing matches" do
    get hotels_path, params: { city: "Несуществующий город" }
    assert_response :success
    assert_match(/По вашему запросу ничего не найдено/, response.body)
  end

  test "hotel detail page renders rooms and reviews" do
    get hotel_path(hotels(:city_hotel))
    assert_response :success
    assert_match(/Одноместный/, response.body)
    assert_match(/Отличный отель/, response.body)
  end
end
