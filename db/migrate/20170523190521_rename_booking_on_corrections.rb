class RenameBookingOnCorrections < ActiveRecord::Migration[5.0]
  def change
    rename_column :corrections, :booking_id, :selection_id
  end
end
