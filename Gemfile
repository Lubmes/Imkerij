source 'https://rubygems.org'
ruby "2.4.0"

gem 'rails', '~> 5.0.0'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
# gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'devise', '~> 4.2'
gem 'pundit', '~> 1.1'
gem 'money-rails', '~> 1.7'
gem 'mollie-api-ruby'
gem 'aws-sdk', '~> 2.10', '>= 2.10.61'
gem 'paperclip', '~> 5.1'
gem 'active_link_to'
gem 'font-awesome-rails'
gem 'acts_as_list'
gem 'redcarpet' # Markdown verwerking naar views.
gem 'flatpickr_rails', '~> 0.0.2'
gem 'mailgun-ruby', '~> 1.1', '>= 1.1.5'
gem 'faraday', '~> 0.9.2'
gem 'savon', '~> 2.11', '>= 2.11.1' # om postnl api calls mee te maken.
gem 'mini_magick' # voor ontvangen postnl (base 64 binary data)=>pdf verdere conversie naar image.

# heroku
gem 'rails_12factor', group: :production
gem "figaro"
# debugging
gem 'awesome_print'
# grafieken
gem 'chartkick', '~> 2.1', '>= 2.1.1'
gem 'groupdate'
# pdf's
gem 'wkhtmltopdf-binary'
gem 'wicked_pdf'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5', '>= 3.5.2'
end

group :development do
  gem 'rails_real_favicon'
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '~> 2.10', '>= 2.10.1'
  gem "capybara-webkit"
  gem "database_cleaner"
  gem "shoulda-matchers"
  gem 'pundit-matchers', '~> 1.1'
  gem 'factory_girl_rails', '~> 4.7'
  gem "email_spec"
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
