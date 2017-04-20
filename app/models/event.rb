class Event < ApplicationRecord
  # Validaties
  validates_presence_of :name, :description, :date, :pictures
  validates :name, length: { maximum: 100 }
  validates :description, length: { maximum: 500 }
  validates :date, in_future: true
  # validates_presence_of :pictures # stopt de create actie
  # Associaties
  has_many :pictures, -> { order(position: :asc) }, as: :imageable, dependent: :destroy
end
