module Api
  module V1
    class BaseController < ActionController::API
      before_action :authenticate_token_optional!

      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
      rescue_from ActionController::ParameterMissing, with: :render_bad_request

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

      def parse_date(value)
        Date.parse(value.to_s)
      rescue ArgumentError, TypeError
        nil
      end

      def render_errors(record)
        render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
      end

      def photo_urls(record)
        return [] unless record.photos.attached?
        record.photos.map do |p|
          { id: p.id, url: Rails.application.routes.url_helpers.rails_blob_url(p, host: request.base_url) }
        end
      end

      def photo_url(record)
        photo_urls(record).first&.dig(:url)
      end

      def param_any(*keys)
        keys.each do |k|
          v = params[k]
          return v if v.present?
        end
        nil
      end

      def render_not_found(exception = nil)
        render json: { error: "Не найдено" }, status: :not_found
      end

      def render_unprocessable_entity(exception)
        errors = exception.respond_to?(:record) ? exception.record.errors.full_messages : [exception.message]
        render json: { errors: errors }, status: :unprocessable_entity
      end

      def render_bad_request(exception = nil)
        render json: { error: "Неверные параметры запроса" }, status: :bad_request
      end
    end
  end
end
