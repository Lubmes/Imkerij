class Delivery < ApplicationRecord
  enum kind_of: { package: 0, facturation: 1 }
  belongs_to :sender, class_name: 'User'
  has_address :address
end
