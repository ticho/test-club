module SessionsHelper
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns the current logged-in user (if any).
  def current_user
    if (user_id = session[:user_id])
      return @current_user ||= User.find_by(id: user_id)
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    @current_user = nil
    session.delete(:user_id)
  end

  # Redirect if wrong user
  def check_user
    if !logged_in? || current_user.id.to_i != params[:id].to_i
      flash[:danger] = "You don't have access rights to this user's page"
      redirect_to root_path
    end
  end
end
