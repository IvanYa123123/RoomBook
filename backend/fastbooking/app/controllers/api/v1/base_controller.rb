module Api
  module V1
    class BaseController < ActionController::API
      before_action :authenticate_token_optional!

      private

      attr_reader :current_user

      def authenticate_token_optional!
        token = request.headers["Authorization"].to_s.delete_prefix("Bearer ").strip
        @current_user = User.find_by(api_token: token) if token.present?
      end

      def require_guest!
        return render(json: { error: "Требуется вход" }, status: :unauthorized) unless current_user
        render(json: { error: "Доступно только гостям" }, status: :forbidden) unless current_user.guest?
      end

      def require_host!
        return render(json: { error: "Требуется вход" }, status: :unauthorized) unless current_user
        render(json: { error: "Доступно только владельцам отелей" }, status: :forbidden) unless current_user.host?
      end

      def render_errors(record)
        render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
      end

      def parse_date(value)
        Date.parse(value.to_s)
      rescue ArgumentError, TypeError
        nil
      end

      def photo_urls(record)
        return [] unless record.photos.attached?
        record.photos.map do |photo|
          {
            id: photo.id,
            url: Rails.application.routes.url_helpers.rails_blob_url(photo, host: request.base_url)
          }
        end
      end

      def photo_url(record)
        photo_urls(record).first&.dig(:url)
      end

      def serialize_user(user)
        {
          id: user.id,
          email: user.email,
          first_name: user.first_name,
          last_name: user.last_name,
          full_name: user.full_name,
          role: user.role
        }
      end
    end
  end
end
