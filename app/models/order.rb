class Order < ApplicationRecord
  # Money: total
  monetize :total_price_cents
  # Statuses
  enum status: { open: 0, confirmed: 1, paid: 2, stored: 3, sent: 4, problem: 5 }
  # Associations
  belongs_to :package_delivery, class_name: 'Delivery', optional: true
  belongs_to :customer, class_name: 'User', optional: true
  has_many :bookings, dependent: :destroy
  has_many :invoices
  # Nested attributes
  accepts_nested_attributes_for :customer # Waarom? => invoice!

  # Om naar de mollie API te sturen.
  def total_price_in_euros
    sprintf("%03d", total_price_cents).insert(-3, ".")
  end

  def bookable?
    self.status == 'open' || self.status == 'confirmed'
  end

  def sum_all_bookings
    bookings = self.bookings
    sum_money = 0
    sum_mass = 0
    bookings.each do |booking|
      sum_money += booking.product_quantity * booking.product_price_cents
      sum_mass += booking.product_quantity * booking.product_mail_weight
    end
    self.total_price_cents = sum_money
    self.total_mail_weight = sum_mass
  end

  def self.sum_of_all_orders
    sum = Order.sum(:total_price_cents)
    Money.new(sum)
  end

  def self.sum_of_current_months_orders
    @orders = Order.where(updated_at: Time.now.beginning_of_month..Time.now)
    sum = @orders.sum(:total_price_cents)
    Money.new(sum)
  end

  def self.sum_of_previous_months_orders
    @orders = Order.where(
      updated_at: (Time.now.beginning_of_month - 1.month)..Time.now.beginning_of_month)
    sum = @orders.sum(:total_price_cents)
    Money.new(sum)
  end

  def self.sum_of_todays_orders
    @orders = Order.where(updated_at: Time.now.beginning_of_day..Time.now)
    sum = @orders.sum(:total_price_cents)
    Money.new(sum)
  end
end
