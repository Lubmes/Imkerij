class AddColumnsToBooking < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :product_mail_weight, :integer
    add_column :bookings, :product_sales_tax, :decimal, precision: 3, scale: 1
  end
end
