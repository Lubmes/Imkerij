class AddPackageDeliveryToOrders < ActiveRecord::Migration[5.0]
  def change
    add_reference :orders, :package_delivery, index: true
    add_foreign_key :orders, :deliveries, column: :package_delivery_id
  end
end
