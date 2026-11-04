ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
    fixtures :all

    def sign_in(user, password: "password123")
      post login_path, params: { email: user.email, password: password }
    end

    def auth_headers(user)
      user.ensure_api_token!
      { "Authorization" => "Bearer #{user.api_token}" }
    end
  end
end
