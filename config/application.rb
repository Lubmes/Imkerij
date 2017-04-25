require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ImkerijWebshop
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.i18n.default_locale = :nl

    # Aws.config.update({region: 'eu-west-1'})
    #   config.paperclip_defaults = {
    #     :storage    => :s3,
    #     :s3_region  => ENV['AWS_REGION'],
    #     :s3_credentials => {
    #       :bucket             => ENV['AWS_BUCKET'],
    #       :access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
    #       :secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY']
    #     }
    #   }
    Figaro.require_keys("aws_access_key_id", "aws_secret_access_key")
    config.secret_key_base = Figaro.env.secret_key_base
  end
end
