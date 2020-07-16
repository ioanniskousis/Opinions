class LikesController < ApplicationController
  before_action :require_login

  def create
    @current_user = User.find(session[:user_id])
    @current_user.likes_opinion(params[:format])

    case params[:direction]
    when 'root'
      redirect_to root_path(anchor: params[:anchor])
    when 'user'
      redirect_to user_path(params[:view_user], view: 'opinions', anchor: params[:anchor])
    end
  end

  def destroy
    @current_user = User.find(session[:user_id])
    @current_user.unlikes_opinion(params[:id])

    case params[:direction]
    when 'root'
      redirect_to root_path(anchor: params[:anchor])
    when 'user'
      redirect_to user_path(params[:view_user], view: 'opinions', anchor: params[:anchor])
    end
  end

  private

  def like_params
    params.require(:like).permit(:user_id, :opinion_id)
  end
end
