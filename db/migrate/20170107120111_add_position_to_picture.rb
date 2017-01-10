class AddPositionToPicture < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :position, :integer
  end
end
