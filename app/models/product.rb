class Product < ApplicationRecord
  acts_as_list scope: :category
  # Money: price
  monetize :price_cents, :allow_nil => true, :numericality => { :greater_than_or_equal_to => 0 }
  # Associaties
  belongs_to :category
  has_many :orders, through: :bookings
  has_many :bookings, dependent: :nullify
  has_many :pictures, -> { order(position: :asc) }, as: :imageable, dependent: :destroy
  # Validaties
  validates :name, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :mail_weight, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true

  def sales_tax=(val)
    val.sub!(',', '.') if val.is_a?(String)
    self['sales_tax'] = val
  end
end
