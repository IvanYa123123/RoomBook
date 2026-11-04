class RegistrationsController < ApplicationController
  def new
    return redirect_to(root_path, notice: "Вы уже зарегистрированы") if logged_in?
    @user = User.new
  end

  def create
    @user = User.new(registration_params)
    @user.role = params.dig(:user, :role).presence_in(%w[guest host]) || "guest"

    if @user.save
      session[:user_id] = @user.id
      redirect_to(@user.host? ? host_hotels_path : guest_bookings_path, notice: "Регистрация прошла успешно")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
  end
end
