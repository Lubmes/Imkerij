class Picture < ApplicationRecord
  acts_as_list
  belongs_to :imageable, polymorphic: true, optional: true

  has_attached_file :image,
    :storage    => :s3,
    :bucket     => Figaro.env.s3_bucket,
    :s3_region  => 'eu-west-1',
    :s3_credentials => {
      :access_key_id      => Figaro.env.aws_access_key_id,
      :secret_access_key  => Figaro.env.aws_secret_access_key
    }

  do_not_validate_attachment_file_type :image
end
