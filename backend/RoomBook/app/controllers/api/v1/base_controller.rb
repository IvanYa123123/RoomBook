module Api
  module V1
    class BaseController < ActionController::API
      before_action :authenticate_token_optional!

      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
      rescue_from ActionController::ParameterMissing, with: :render_bad_request

      private

      attr_reader :current_user

      # Bearer регистронезависим ("bearer", "BEARER" — ок).
      def authenticate_token_optional!
        token = request.headers["Authorization"].to_s.sub(/\ABearer\s+/i, "").strip
        @current_user = User.find_by(api_token: token) if token.present?
      end

      def require_guest!
        return render(json: { error: "Требуется вход" }, status: :unauthorized) unless current_user
        return render(json: { error: "Доступно только гостям" }, status: :forbidden) unless current_user.guest?
      end

      def require_host!
        return render(json: { error: "Требуется вход" }, status: :unauthorized) unless current_user
        return render(json: { error: "Доступно только владельцам отелей" }, status: :forbidden) unless current_user.host?
      end

      # Строгий формат YYYY-MM-DD; мусор → nil → фильтр не применяется.
      def parse_date(value)
        return nil if value.blank?
        Date.iso8601(value.to_s)
      rescue ArgumentError, TypeError
        nil
      end

      def render_errors(record)
        render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
      end

      # Возвращает значение и для snake_case, и для camelCase ключей.
      # Учитывает false/0 (presence "съел" бы их).
      def param_any(*keys)
        keys.each do |k|
          return params[k] if params.key?(k) && !params[k].nil?
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
