class Correction < ApplicationRecord
  belongs_to :booking
  # belongs_to :invoice

  def total_amount
    booking.product_price * quantity
  end
end
