class Order < ApplicationRecord
  # Money: total
  monetize :total_price_cents
  # Statuses
  enum status: { open: 0, paid: 1, stored: 2, sent: 3, problem: 4 }
  # Associations
  belongs_to :customer, class_name: 'User', optional: true
  accepts_nested_attributes_for :customer
  has_many :bookings, dependent: :destroy
  has_many :deliveries

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
