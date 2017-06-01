class Delivery < ApplicationRecord
  enum kind_of: { package: 0, facturation: 1 }
  belongs_to :sender, class_name: 'User'
  has_many :orders, foreign_key: "package_delivery_id"
  has_many :invoices, foreign_key: "invoices_delivery_id"

  has_address :address

  def address_short
    "#{address_zip_code}, #{address_street_number}"
  end

  # Bewerkbaar als een delivery nog niet is gekoppeld aan een betaalde order.
  def editable?
    if self.orders.where.not(payment_id: nil).any?
      false
    else
      true
    end
  end
end
