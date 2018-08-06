class UsersController < ApplicationController
  include SessionsHelper

  def create
    user = User.new(user_params)
    if !user.save
      flash["danger"] = "Erreur, veuillez reessayer."
      redirect_to new_user_path
    else
      log_in(user)
      flash["success"] = "Inscription validée ! Vous avez maintenant accès à la page club."
      redirect_to root_path
    end
  end

  def show
    if !logged_in?
      flash["danger"] = "Vous devez vous connecter pour acceder à cette page."
      redirect_to root_path
    elsif request.env['PATH_INFO'] != "/users/#{current_user.id}"
      flash["danger"] = 'Vous n\'avez pas accès à la page de cet utilisateur.'
      redirect_to root_path
    end
    @user = current_user
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
