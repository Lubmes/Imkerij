class Delivery < ApplicationRecord
  enum kind_of: { package: 0, facturation: 1 }
  belongs_to :sender, class_name: 'User'
  has_many :orders, foreign_key: "package_delivery_id"
  has_many :invoices, foreign_key: "invoices_delivery_id"

  has_address :address
end
