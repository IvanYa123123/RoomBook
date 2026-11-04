require "active_support/core_ext/integer/time"

Rails.application.configure do
config.enable_reloading = true
config.eager_load = false
config.consider_all_requests_local = true
config.server_timing = true

if Rails.root.join("tmp/caching-dev.txt").exist?
config.action_controller.perform_caching = true
config.action_controller.enable_fragment_cache_logging = true
config.cache_store = :memory_store
config.public_file_server.headers = { "Cache-Control" => "public, max-age=#{2.days.to_i}" }
else
config.action_controller.perform_caching = false
config.cache_store = :null_store
end

config.active_storage.service = :local

config.action_mailer.raise_delivery_errors = false
config.action_mailer.perform_caching = false
config.action_mailer.default_url_options = { host: "localhost", port: 3000 }

config.active_support.deprecation = :log
config.active_support.disallowed_deprecation = :raise
config.active_support.disallowed_deprecation_warnings = []

config.active_record.migration_error = :page_load
config.active_record.verbose_query_logs = true

config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end

</BDS:create_file>

<BDS:create_file fileName="backend/RoomBook/config/environments/production.rb">```ruby
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

