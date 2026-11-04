class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.references :hotel, null: false, foreign_key: true, index: true
      t.references :booking, null: false, foreign_key: true, index: { unique: true }
      t.integer :rating, null: false
      t.text :body

      t.timestamps
    end

    add_index :reviews, %i[hotel_id created_at]
  end
end
