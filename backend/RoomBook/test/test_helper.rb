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