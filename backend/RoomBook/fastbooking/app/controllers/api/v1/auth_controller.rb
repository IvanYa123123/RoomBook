module Api
  module V1
    class AuthController < BaseController
      def signup
        user = User.new(
          email: params[:email],
          password: params[:password],
          password_confirmation: params[:password_confirmation].presence || params[:password],
          first_name: params[:first_name] || params[:firstName],
          last_name: params[:last_name] || params[:lastName],
          role: (params[:role].presence_in(%w[guest host]) || "guest")
        )

        if user.save
          render json: { token: user.api_token, user: UserSerializer.call(user) }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
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
