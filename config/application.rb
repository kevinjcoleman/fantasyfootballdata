require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Fantasyfootballdata
  class Application < Rails::Application
    config.assets.precompile << 'delayed/web/application.css'
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    Raven.configure do |config|
      config.dsn = 'https://36e71880da914ef0929c2380563f806c:0200e54ce2ee41a395760e79697be129@sentry.io/203494'
    end
  end
end
