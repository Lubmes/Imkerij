class Product < ApplicationRecord
  # Money: price
  monetize :price_cents, :allow_nil => true, :numericality => { :greater_than_or_equal_to => 0 }
  # Associaties
  belongs_to :category
  has_many :orders, through: :bookings
  has_many :bookings, dependent: :nullify
  has_many :pictures, as: :imageable, dependent: :destroy
  # Validaties
  validates :name, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 500 }
  # validates :price, presence: true
  # validates :price, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }

  def sales_tax=(val)
    val.sub!(',', '.') if val.is_a?(String)
    self['sales_tax'] = val
  end
end
