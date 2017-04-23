class Picture < ApplicationRecord
  acts_as_list
  belongs_to :imageable, polymorphic: true

  has_attached_file :image,
    # :path           => ":rails_root/public/images/:id/:filename",
    # :url            => "/images/:id/:filename"
    :storage    => :s3,
    :bucket     => ENV["s3_bucket"],
    :s3_region  => ENV["s3_region"],
    :s3_credentials => {
      :access_key_id      => ENV["s3_access_key_id"],
      :secret_access_key  => ENV["s3_secret_access_key"]
    }

  do_not_validate_attachment_file_type :image

  # validates_attachment_presence :image
end
