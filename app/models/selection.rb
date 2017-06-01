class Selection < ApplicationRecord
  # Money: product_price
  monetize :product_price_cents
  # Associaties
  belongs_to :product, optional: true
  belongs_to :order
  has_many :corrections, dependent: :destroy
  # Validations
  validates :product_quantity, presence: true,
              numericality: { only_integer: true, greater_than: 0 }
  validates :order, presence: true
  validates_uniqueness_of :order_id, scope: :product_id
  # Actions
  after_commit do
    order.sum_all_selections
  end

  def total_price
    product_price * product_quantity
  end

  def total_mail_weight
    product_mail_weight * product_quantity
  end

  def correctable_quantity
    sum = self.corrections.joins(:invoice).where(invoices: { closed: true }).sum(:quantity).abs
    self.product_quantity - sum
  end

  def correctable?(quantity = 0)
    self.correctable_quantity - quantity > 0
  end
end
