class AddAvailableToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :available, :boolean, default: true
  end
end
