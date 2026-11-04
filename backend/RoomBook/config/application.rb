require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module RoomBook
  class Application < Rails::Application
    config.load_defaults 7.1

    config.i18n.default_locale = :ru
    config.i18n.available_locales = %i[ru en]
    config.i18n.fallbacks = [:en]

    config.time_zone = "Moscow"
    config.active_record.default_timezone = :utc

    config.generators do |g|
      g.system_tests = nil
      g.test_framework :test_unit, fixture: true
    end
  end
end