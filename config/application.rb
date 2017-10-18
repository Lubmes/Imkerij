require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ImkerijWebshop
  class Application < Rails::Application
    config.autoload_paths << Rails.root.join('lib')
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.i18n.default_locale = :nl
    config.time_zone = 'Amsterdam'

    config.load_defaults 5.1
    Rails.application.config.active_record.belongs_to_required_by_default = false

  end
end
