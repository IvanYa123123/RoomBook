class AddTrgmIndexToHotels < ActiveRecord::Migration[7.1]
  def change
    enable_extension "pg_trgm"
    add_index :hotels, :city, using: :gin, opclass: :gin_trgm_ops,
              name: "index_hotels_on_city_trgm"
  end
end
