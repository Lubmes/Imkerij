class CreateDeliveries < ActiveRecord::Migration[5.0]
  def change
    create_table :deliveries do |t|
      t.column :kind_of, :integer
      t.address :address

      t.timestamps
    end

    add_reference :deliveries, :sender, index: true
    add_foreign_key :deliveries, :users, column: :sender_id
  end
end
