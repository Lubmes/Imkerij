class RenameBookingsToSelections < ActiveRecord::Migration[5.0]
  def change
    rename_table :bookings, :selections
  end
end
