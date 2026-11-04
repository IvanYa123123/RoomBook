module Api
  module V1
    class AuthController < BaseController
      def signup
        user = User.new(
          email: params[:email],
          password: params[:password],
          password_confirmation: param_any(:password_confirmation, :passwordConfirmation) || params[:password],
          first_name: param_any(:first_name, :firstName),
          last_name: param_any(:last_name, :lastName),
          role: param_any(:role).presence_in(%w[guest host]) || "guest"
        )

        if user.save
          render json: { token: user.api_token, user: UserSerializer.call(user) }, status: :created
        else
          render_errors(user)
        end
      end

      def login
        user = User.find_by(email: params[:email].to_s.strip.downcase)

        if user&.authenticate(params[:password].to_s)
          user.ensure_api_token!
          render json: { token: user.api_token, user: UserSerializer.call(user) }
        else
          render json: { error: "Неверный e-mail или пароль" }, status: :unauthorized
        end
      end

      def me
        return render(json: { error: "Требуется вход" }, status: :unauthorized) unless current_user
        render json: { user: UserSerializer.call(current_user) }
      end

      def logout
        current_user&.update_column(:api_token, SecureRandom.hex(32))
        head :no_content
      end
    end
  end
end
