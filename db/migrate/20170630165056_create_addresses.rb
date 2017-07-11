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

    remove_column :deliveries, :address_formatted_address, :string
    remove_column :deliveries, :address_street_number, :string
    remove_column :deliveries, :address_street_name, :string
    remove_column :deliveries, :address_street, :string
    remove_column :deliveries, :address_city, :string
    remove_column :deliveries, :address_zip_code, :string
    remove_column :deliveries, :address_department, :string
    remove_column :deliveries, :address_department_code, :string
    remove_column :deliveries, :address_state, :string
    remove_column :deliveries, :address_state_code, :string
    remove_column :deliveries, :address_country, :string
    remove_column :deliveries, :address_country_code, :string
    remove_column :deliveries, :address_lat
    remove_column :deliveries, :address_lng
  end
end
