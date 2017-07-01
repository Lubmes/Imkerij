class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.belongs_to :delivery, foreign_key: true, index: true
      t.string :street_number
      t.string :street_name
      t.string :zip_code
      t.string :city
      t.string :country
    end

    remove_column :deliveries, :address_formatted_address
    remove_column :deliveries, :address_street_number
    remove_column :deliveries, :address_street_name
    remove_column :deliveries, :address_street
    remove_column :deliveries, :address_city
    remove_column :deliveries, :address_zip_code
    remove_column :deliveries, :address_department
    remove_column :deliveries, :address_department_code
    remove_column :deliveries, :address_state
    remove_column :deliveries, :address_state_code
    remove_column :deliveries, :address_country
    remove_column :deliveries, :address_country_code
  end
end
