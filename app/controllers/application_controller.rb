class ApplicationController < ActionController::Base
  def require_login
    # session[:user_id] = nil
    if session[:user_id]
      true
    else
      redirect_to new_session_path
      false
    end
  end
end
