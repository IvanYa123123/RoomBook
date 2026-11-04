class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :first_name, null: false
      t.string :last_name
      t.integer :role, null: false, default: 0

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :role
  end
end
