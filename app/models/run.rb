class Run < ApplicationRecord
  belongs_to :delivery
  belongs_to :invoice

  before_save :decode_label_data, :if => :label_data_provided?

  has_attached_file :label,
    :storage    => :s3, :s3_protocol => 'https',
    :bucket     => Figaro.env.s3_bucket,
    :s3_region  => 'eu-west-1',
    :s3_credentials => {
      :access_key_id      => Figaro.env.aws_access_key_id,
      :secret_access_key  => Figaro.env.aws_secret_access_key
    }

  validates_attachment_content_type :label, :content_type => %w(application/pdf)


  private

  def label_data_provided?
    !self.label_data.blank?
  end

  def decode_label_data
    # If cover_image_data is set, decode it and hand it over to Paperclip
    data = StringIO.new(Base64.decode64(self.label_data))
    data.class.class_eval { attr_accessor :original_filename, :content_type }
    data.original_filename = SecureRandom.hex(16) + ".pdf"
    data.content_type = "application/pdf"
    self.label = data
    self.label_data = nil
  end
end
