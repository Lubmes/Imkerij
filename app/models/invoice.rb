class Invoice < ApplicationRecord
  # Money: paid, paid_back
  monetize :paid_cents
  monetize :paid_back_cents
  # Associations
  belongs_to :order
  has_many :corrections
  belongs_to :invoice_delivery, class_name: 'Delivery', optional: true
  has_many :runs

  def sequence_number
    order = self.order
    invoices = order.invoices.order(created_at: :asc)
    invoices.find_index(self) + 1
  end

  # Factuur-nummer voor in de factuur en op bankafschriften.
  def storewide_identification_number
    "KLNT#{self.order.customer.id}" +
    "BEST#{self.order.sequence_number}" +
    "FACT#{self.sequence_number}" +
    "-#{I18n.l self.updated_at, format: :invoice}"
  end

  # Om naar de mollie API te sturen.
  def paid_back_in_euros
    sprintf("%03d", paid_back_cents.abs).insert(-3, ".")
  end

  def sum_all_corrections
    corrections = self.corrections
    sum_money = 0
    sum_mass = 0
    corrections.each do |correction|
      sum_money += correction.quantity * correction.selection.product_price_cents
      sum_mass += correction.quantity * correction.selection.product_mail_weight
    end

    self.total_mail_weight = original_mail_weight_order + sum_mass
    # iets met post kosten
    self.paid_back_cents = sum_money
  end

  def already_paid_back
    already_paid_back = 0
    if self.sequence_number > 2
      order = self.order
      invoices = order.invoices.order(created_at: :asc)
      invoices[1, self.sequence_number - 2].each do |invoice|
        already_paid_back += invoice.sum_all_corrections
      end
    end
    Money.new(already_paid_back)
  end

  def received_value
    self.paid + self.paid_back
  end

  def original_mail_weight_order
    order = self.order
    order.total_mail_weight
  end

  def self.filter(start_time)
    where('updated_at < 0', Time.zone.now)
  end
end
