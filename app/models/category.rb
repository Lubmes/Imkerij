class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :pictures, as: :imageable, dependent: :destroy

  # Validaties
  validates :name, presence: true, length: { maximum: 100 }
end