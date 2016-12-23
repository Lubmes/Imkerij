class AddColumnsToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :total_mail_weight, :integer
  end
end
