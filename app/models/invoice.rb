class Invoice < ApplicationRecord
  # Money: paid, paid_back
  monetize :paid_cents
  monetize :paid_back_cents
  # Associations
  belongs_to :order
  has_many :corrections
  belongs_to :invoice_delivery, class_name: 'Delivery', optional: true

  def sum_all_corrections
    corrections = self.corrections
    sum_money = 0
    sum_mass = 0
    corrections.each do |correction|
      sum_money += correction.quantity * correction.booking.product_price_cents
      sum_mass += correction.quantity * correction.booking.product_mail_weight
    end

    self.total_mail_weight = original_mail_weight_order + sum_mass
    # iets met post kosten
    self.paid_back_cents = sum_money
  end

  def original_mail_weight_order
    order = self.order
    order.total_mail_weight
  end

  def received_value
    self.paid + self.paid_back
  end
end
