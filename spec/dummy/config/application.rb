require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require "catherine"

module Dummy
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.railties_order = [:main_app, Catherine::Engine, Usman::Engine, :all]
  end
end

