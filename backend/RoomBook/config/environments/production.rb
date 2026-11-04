require "active_support/core_ext/integer/time"

Rails.application.configure do
config.enable_reloading = false
config.eager_load = true
config.consider_all_requests_local = false
config.action_controller.perform_caching = true

config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

config.active_storage.service = :local

config.force_ssl = true

config.log_level = :info
config.log_tags = [:request_id]

config.action_mailer.perform_caching = false
config.action_mailer.default_url_options = { host: ENV.fetch("APP_HOST", "example.com") }

config.i18n.fallbacks = true
config.active_support.report_deprecations = false
config.active_record.dump_schema_after_migration = false
end

</BDS:create_file>

<BDS:create_file fileName="backend/RoomBook/test/test_helper.rb">```ruby
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
    fixtures :all

    # Возвращает HTTP-заголовки для запросов к JSON API.
    def auth_headers(user)
      user.ensure_api_token!
      { "Authorization" => "Bearer #{user.api_token}" }
    end
  end
end

