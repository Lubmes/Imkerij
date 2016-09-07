class AddDetailsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :street, :string
    add_column :users, :number, :string
    add_column :users, :postcode, :string
    add_column :users, :city, :string
    add_column :users, :country, :string
    add_column :users, :admin, :boolean, default: false
  end
end
