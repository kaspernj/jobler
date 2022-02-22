require File.expand_path("boot", __dir__)

# Pick the frameworks you want:
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie" unless Gem.loaded_specs["rails"].version.to_s.start_with?("7.")
# require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)
require "jobler"

module Dummy; end

class Dummy::Application < Rails::Application
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
  # config.time_zone = 'Central Time (US & Canada)'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  config.i18n.available_locales = [:da, :en]
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
  config.i18n.default_locale = :en
end
