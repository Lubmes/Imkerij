class Picture < ApplicationRecord
  acts_as_list
  belongs_to :imageable, polymorphic: true

  has_attached_file :image,
    # :path           => ":rails_root/public/images/:id/:filename",
    # :url            => "/images/:id/:filename"
    :storage    => :s3,
    :bucket     => 'ENV["AWS_BUCKET"]',
    :s3_region  => 'eu-west-1'
    :s3_credentials => {
      :access_key_id      => ENV["AWS_ACCESS_KEY"],
      :secret_access_key  => ENV["AWS_SECRET_ACCESS_KEY"]
    }

  do_not_validate_attachment_file_type :image

  # validates_attachment_presence :image
end
