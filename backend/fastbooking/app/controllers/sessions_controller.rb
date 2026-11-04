class SessionsController < ApplicationController
  def new
    return redirect_to(root_path, notice: "Вы уже вошли") if logged_in?
  end

  def create
    user = User.find_by(email: params[:email].to_s.strip.downcase)

    if user&.authenticate(params[:password].to_s)
      session[:user_id] = user.id
      redirect_to(session.delete(:return_to) || default_path_for(user),
                  notice: "Добро пожаловать, #{user.first_name}!")
    else
      flash.now[:alert] = "Неверный e-mail или пароль"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "Вы вышли из системы"
  end

  private

  def default_path_for(user)
    user.host? ? host_hotels_path : guest_bookings_path
  end
end
