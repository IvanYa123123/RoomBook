class AddConstraintsToBookings < ActiveRecord::Migration[7.1]
  def up

    enable_extension "btree_gist"


    add_check_constraint :bookings, "check_out > check_in",
                         name: "bookings_dates_check"

    execute <<~SQL
      ALTER TABLE bookings
      ADD CONSTRAINT bookings_no_overlap
      EXCLUDE USING gist (
        room_id WITH =,
        daterange(check_in, check_out, '[)') WITH &&
      )
      WHERE (status IN (0, 1))
    SQL
  end

  def down
    execute "ALTER TABLE bookings DROP CONSTRAINT IF EXISTS bookings_no_overlap"
    remove_check_constraint :bookings, name: "bookings_dates_check"
  end
end
