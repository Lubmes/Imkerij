class Event < ApplicationRecord
  # Validaties
  validates :name, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :date, in_future: true
end
