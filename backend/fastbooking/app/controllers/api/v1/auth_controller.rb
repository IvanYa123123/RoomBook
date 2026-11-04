module Api
  module V1
    class AuthController < BaseController
      def signup
        user = User.new(
          email: params[:email],
          password: params[:password],
          password_confirmation: params[:password_confirmation].presence || params[:password],
          first_name: params[:first_name],
          last_name: params[:last_name],
          role: params[:role].presence_in(%w[guest host]) || "guest"
        )

        if user.save
          render json: { token: user.api_token, user: serialize_user(user) }, status: :created
        else
          render_errors(user)
        end
      end

      def login
        user = User.find_by(email: params[:email].to_s.strip.downcase)

        if user&.authenticate(params[:password].to_s)
          user.ensure_api_token!
          render json: { token: user.api_token, user: serialize_user(user) }
        else
          render json: { error: "Неверный e-mail или пароль" }, status: :unauthorized
        end
      end

      def me
        return render(json: { error: "Требуется вход" }, status: :unauthorized) unless current_user
        render json: { user: serialize_user(current_user) }
      end

      def logout
        current_user&.update_column(:api_token, SecureRandom.hex(32))
        head :no_content
      end
    end
  end
end
