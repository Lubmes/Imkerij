class AddColumnsToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :mail_weight, :integer
    add_column :products, :sales_tax, :decimal, precision: 3, scale: 1
  end
end
