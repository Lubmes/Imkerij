class AddPaymentIdToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :payment_id, :string
  end
end
