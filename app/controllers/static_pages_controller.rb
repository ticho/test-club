class StaticPagesController < ApplicationController
  include SessionsHelper

  def index
  end

  # access to the club page only if logged in
  def club
    if !logged_in?
      flash["danger"] = "Vous devez vous connecter pour accéder à cette page."
      redirect_to root_path
    end
    @users = User.all
  end
end
