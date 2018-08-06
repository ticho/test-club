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
      redirect_to new_session_path
    end
    @user = User.find(params[:id])
  end

  def edit
    if !logged_in?
      flash["danger"] = "Vous devez vous connecter pour modifier ce profil."
      redirect_to new_session_path
    elsif request.env['PATH_INFO'] != "/users/#{current_user.id}/edit"
      flash["danger"] = 'Vous ne pouvez pas modifier ce profil.'
      redirect_to root_path
    end
    @user = current_user
  end
  
  def update
    if request.env['PATH_INFO'] != "/users/#{current_user.id}"
      flash["danger"] = 'Vous ne pouvez pas modifier ce profil.'
      redirect_to root_path
    elsif current_user.update(user_params)
      flash["success"] = "Modifications effectuées."
      redirect_to root_path
    else
      flash["danger"] = "Profil non sauvegardé."
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
