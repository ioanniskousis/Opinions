class FollowingsController < ApplicationController
  before_action :require_login

  def create
    @followed = User.find(params[:user])
    @current_user = User.find(session[:user_id])
    @current_user.follow_user(@followed)

    case params[:direction]
    when 'root'
      redirect_to root_path
    when 'users'
      redirect_to users_path(view: params[:view])
    when 'user'
      redirect_to user_path(params[:view_user], view: params[:view])
    end
  end

  def destroy
    @current_user = User.find(session[:user_id])
    user_id = params[:id]
    @followed = User.find(user_id)
    @current_user.unfollow_user(@followed)

    redirect_to user_path(user_id, view: 'details')
  end
end
