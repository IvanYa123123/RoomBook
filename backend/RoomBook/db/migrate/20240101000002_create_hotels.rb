class CreateHotels < ActiveRecord::Migration[7.1]
  def change
    create_table :hotels do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.string :name, null: false
      t.string :city, null: false
      t.string :address, null: false
      t.text :description

      t.timestamps
    end

    add_index :hotels, :city
  end
end
