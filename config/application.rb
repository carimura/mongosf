require File.expand_path('../boot', __FILE__)

#require 'rails/all'

require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "rails/test_unit/railtie"


# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Mongo1
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{Rails.root}/lib)

      # Only load the plugins named here, in the order given (default is alphabetical).
      # :all can be used as a placeholder for all plugins not explicitly named.
      # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

      # Activate observers that should always be running.
      # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

      # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
      # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
      # config.time_zone = 'Central Time (US & Canada)'

      # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
      # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
      # config.i18n.default_locale = :de

      # JavaScript files you want as :defaults (application.js is always included).
      # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

      # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

      # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
  end
end


Twitter.configure do |config|
  config.consumer_key = "Q9OKOLrAeXxmZOXveNOJxQ"
  config.consumer_secret = "lf5hI1YnpjgqPMj6D3jjTS14ep6gfQHDceBRvSUS4Oo"
  config.oauth_token = "19301710-mhcDfd6sqKOLegaQUuy3lSHBhAlU9BgZ30Uf1P0x5"
  config.oauth_token_secret = "CSjqHRtrJURsK48XW4T91KZqq3S3B1C9AtRZFGWAuM"
end


SimpleWorker.configure do |config|
  config.access_key = '255b3cf400705829cdea38c3cf64c05a'
  config.secret_key = 'da26b508f3eb9996477497e115fe34db'
end

MONGOID = YAML.load_file("#{Rails.root}/config/mongoid.yml")