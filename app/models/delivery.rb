class Delivery < ApplicationRecord
  enum kind_of: { package: 0, facturation: 1 }
  belongs_to :sender, class_name: 'User'
  has_many :orders, foreign_key: "package_delivery_id"
  has_many :invoices, foreign_key: "invoices_delivery_id"
  has_one :address
  has_many :runs
  accepts_nested_attributes_for :address

  def address_short
    "#{address.street_number}, #{address.zip_code}"
  end

  # Bewerkbaar als een delivery nog niet is gekoppeld aan een order door betaling gesluisd.
  def editable?
    if (self.orders.where(status: :paid)
        .or(self.orders.where(status: :sent))
        .or(self.orders.where(status: :problem))).any?
      false
    else
      true
    end
  end
end
