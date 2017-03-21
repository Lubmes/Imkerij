class Page < ApplicationRecord
  has_many :pictures, -> { order(position: :asc) }, as: :imageable, dependent: :destroy
end
