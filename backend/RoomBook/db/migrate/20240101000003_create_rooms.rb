class CreateRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :rooms do |t|
      t.references :hotel, null: false, foreign_key: true, index: true
      t.string :name, null: false
      t.integer :capacity, null: false, default: 1
      t.decimal :price_per_night, precision: 10, scale: 2, null: false
      t.text :description
      t.string :amenities

      t.timestamps
    end

    add_index :rooms, :price_per_night
  end
end
