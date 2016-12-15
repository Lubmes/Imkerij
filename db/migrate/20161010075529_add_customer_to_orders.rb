class AddCustomerToOrders < ActiveRecord::Migration[5.0]
  def change
    add_reference :orders, :customer, index: true
    add_foreign_key :orders, :users, column: :customer_id
  end
end