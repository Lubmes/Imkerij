class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.column :status, :integer
      t.timestamps
    end

    add_monetize :orders, :total
  end
end
