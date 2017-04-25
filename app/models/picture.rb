class Picture < ApplicationRecord
  acts_as_list
  belongs_to :imageable, polymorphic: true

  has_attached_file :image,
    :storage    => :s3,
    :bucket     => Figaro.env.s3_bucket,
    :s3_region  => 'eu-west-1'

  do_not_validate_attachment_file_type :image
end
