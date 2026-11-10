require_relative "boot"

require "rails"
# Only the frameworks CampusEats uses
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"

Bundler.require(*Rails.groups)

module CampusEats
  class Application < Rails::Application
    config.load_defaults 7.2
    config.time_zone = "Riyadh"
  end
end
