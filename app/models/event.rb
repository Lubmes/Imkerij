class Event < ApplicationRecord
  # Validaties
  validates :name, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :date, in_future: true
  # Associaties
  has_many :pictures, -> { order(position: :asc) }, as: :imageable, dependent: :destroy
end
