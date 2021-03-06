class Order < ApplicationRecord
  # scope :starts_at -> (start_time) { where "updated_at >= start_time"  }
  # scope :ends_at -> (end_time) { where "updated_at <= end_time"  }
  # Money: total
  monetize :total_price_cents
  # Statuses
  # enum status: { open: 0, confirmed: 1, paid: 2, stored: 3, sent: 4, problem: 5 }
  enum status: { open: 0, stored: 1, at_check_out: 2, confirmed: 3, paid: 4,  sent: 5, problem: 6 }
  # Associations
  belongs_to :package_delivery, class_name: 'Delivery', optional: true
  belongs_to :customer, class_name: 'User', optional: true
  has_many :selections, dependent: :destroy
  has_many :invoices
  # Nested attributes
  accepts_nested_attributes_for :customer # Waarom? => invoice!

  # Om order nummer in factuur nummer te verwerken.
  def sequence_number
    customer = self.customer
    orders = customer.orders.order(created_at: :asc)
    orders.find_index(self) + 1
  end

  # Om naar de mollie API te sturen.
  def total_price_in_euros
    sprintf("%03d", total_price_cents).insert(-3, ".")
  end

  def bookable?
    self.status == 'open' || self.status == 'confirmed'
  end

  # Defineert de invoice v.d. order die bewerkt kan worden.
  def active_invoice
    if self.invoices.last.closed?
      invoice = self.invoices.first.dup
      invoice.closed = false
      invoice.save!
      invoice
    else
      self.invoices.last
    end
  end

  # Na succes betaling.
  def first_invoice
    self.invoices.first
  end

  # Voor doorgeven BTW.
  def last_closed_invoice
    self.invoices.where(closed: true).last
  end

  def last_closed_invoice_received_value
    money = last_closed_invoice.received_value
    money.cents/100.0
  end

  def sum_all_selections
    selections = self.selections
    sum_money = 0
    sum_mass = 0
    selections.each do |selection|
      sum_money += selection.product_quantity * selection.product_price_cents
      sum_mass += selection.product_quantity * selection.product_mail_weight
    end
    self.total_price_cents = sum_money
    self.total_mail_weight = sum_mass
  end

  # orders voor de infographics
  def self.orders_past_payment
    where.not(status: :open).
    where.not(status: :at_check_out).
    where.not(status: :confirmed)
  end

  def self.sum_of_all_orders
    sum = orders_past_payment.sum{ |o| o.last_closed_invoice.received_value }
    Money.new(sum)
  end

  def self.sum_of_current_months_orders
    @orders = orders_past_payment.where(updated_at: Time.now.beginning_of_month..Time.now)
    sum = @orders.sum{ |o| o.last_closed_invoice.received_value }
    Money.new(sum)
  end

  def self.sum_of_previous_months_orders
    @orders = orders_past_payment.where(
      updated_at: (Time.now.beginning_of_month - 1.month)..Time.now.beginning_of_month)
    sum = @orders.sum{ |o| o.last_closed_invoice.received_value }
    Money.new(sum)
  end

  def self.sum_of_todays_orders
    @orders = orders_past_payment.where(updated_at: Time.now.beginning_of_day..Time.now)
    sum = @orders.sum{ |o| o.last_closed_invoice.received_value }
    Money.new(sum)
  end

  def self.hashify_received_value_over_date_range(start_time, end_time)
    Hash[orders_past_payment.
      group_by_day_of_month(range: start_time..end_time, series: true) { |o| o.updated_at }.map { |k, v| [k, v.sum(&:last_closed_invoice_received_value)] } ]
  end

  def self.hashify_received_value_over_all
    Hash[orders_past_payment.
      group_by_day(series: true) { |o| o.updated_at }.map { |k, v| [k, v.sum(&:last_closed_invoice_received_value)] } ]
  end
end
