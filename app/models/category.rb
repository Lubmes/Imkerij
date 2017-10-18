class Category < ApplicationRecord
  acts_as_list
  ## Associaties
  has_many :products, -> { order(position: :asc) }, dependent: :destroy
  has_many :pictures, -> { order(position: :asc) }, as: :imageable, dependent: :destroy
  ## Validaties
  validates :name, presence: true, length: { maximum: 100 }
end
