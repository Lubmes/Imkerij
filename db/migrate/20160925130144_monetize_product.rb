class MonetizeProduct < ActiveRecord::Migration[5.0]
  def change
    add_monetize :products, :price
  end
end
