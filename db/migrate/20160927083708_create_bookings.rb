class CreateBookings < ActiveRecord::Migration[5.0]
  def change
    create_table :bookings do |t|
      t.belongs_to :order, index: true
      t.belongs_to :product, index: true
      t.string :product_name
      t.integer :product_quantity

      t.timestamps
    end

    add_monetize :bookings, :product_price
  end
end