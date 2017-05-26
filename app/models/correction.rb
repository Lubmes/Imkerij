class Correction < ApplicationRecord
  belongs_to :selection
  belongs_to :invoice

  def total_amount
    selection.product_price * quantity
  end
end
