class AddContentToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :content_weight, :integer
    add_column :products, :content_volume, :integer
  end
end
