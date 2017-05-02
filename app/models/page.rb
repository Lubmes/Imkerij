class Page < ApplicationRecord
  belongs_to :opening_times_widget,
    :foreign_key  => "opening_times_widget_id",
    :class_name   => "InformationWidget"
  accepts_nested_attributes_for :opening_times_widget

  has_many :pictures, -> { order(position: :asc) }, as: :imageable, dependent: :destroy
end
