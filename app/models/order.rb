class Order < ApplicationRecord
  # Money: total
  monetize :total_cents
  # Statuses
  enum status: { open: 0, paid: 1, stored: 2, sent: 3, problem: 4 }
  # Associations
  belongs_to :customer, class_name: 'User', optional: true
  accepts_nested_attributes_for :customer
  has_many :bookings, dependent: :destroy
  has_many :deliveries

  def sum_all_bookings
    bookings = self.bookings
    sum = 0
    bookings.each do |booking|
      sum += booking.product_quantity * booking.product_price_cents
    end
    self.total_cents = sum
  end

  def self.sum_of_all_orders
    sum = Order.sum(:total_cents)
    Money.new(sum)
  end
end
