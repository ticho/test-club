class SessionsController < ApplicationController
  include SessionsHelper

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      log_in(user)
      flash["success"] = "Connection réussie."
      redirect_to root_path
    else
      flash["danger"] = "Adresse email ou mot de passe non valide."
      render :new
    end
  end

  def destroy
    log_out
    flash["success"] = "Vous êtes déconnecté.e."
    redirect_to root_path
  end
end
