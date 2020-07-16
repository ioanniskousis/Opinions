class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :require_login, except: %i[new create]

  def index
    @user_view = params[:view]
    @user_view = 'all' if @user_view.nil?
    @direction = 'users'

    @users = User.all.includes(:photo_blob).order(username: :asc)

    setup_current_user
    setup_matrices
    sort_users
    setup_followings
  end

  def show
    @user_view = params[:view]
    @user_view = 'details' if @user_view.nil?
    @direction = 'user'
    @user = User.includes(:photo_blob, :cover_blob).find(params[:id])

    setup_current_user
    setup_matrices
    setup_followings

    return unless @user_view == 'opinions'

    @opinion = @user.opinions.new
    @likes = Like.all
    @opinions = @user.opinions.includes({ author: :photo_blob }).ordered_by_most_recent
  end

  def new
    @caption = 'New User Signup'
    @user = User.new
    @direction = 'new_user'
  end

  def edit
    setup_current_user
    setup_matrices

    @user = @current_user
    @caption = 'Edit User Details'
    @direction = 'user'
    setup_followings
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path(direction: 'root')
    else
      flash[:alert] = @user.errors.full_messages
      redirect_to new_user_path
    end
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      redirect_to edit_user_path
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :fullname, :photo, :coverimage)
  end

  def setup_current_user
    @current_user = User.includes(:photo_blob).find(session[:user_id])

    @current_user_followers = []
    @current_user.followers.each { |u| @current_user_followers << u.id }
    @current_user_followees = []
    @current_user.followed.each { |u| @current_user_followees << u.id }
  end

  def setup_matrices
    @followers_matrix = User.popular_matrix
    @followees_matrix = User.friendly_matrix
    @opinions_matrix = User.opinions_matrix
  end

  def setup_followings
    setup_users_followings if @direction == 'users'

    setup_user_followings if @direction == 'user'
  end

  def setup_users_followings
    @to_follow = User.includes(:photo_blob).where('id NOT IN (?)', User.user_followed(@current_user))
    @followers = @current_user.followers.includes(:photo_blob)
  end

  def setup_user_followings
    @followings = @user.followed.includes(:photo_blob) if @user_view == 'following'
    @followers = @user.followers.includes(:photo_blob)
  end

  def sort_users
    sort_popular if @user_view == 'popular'

    sort_friendly if @user_view == 'friendly'

    sort_protagonists if @user_view == 'protagonists'
  end

  def sort_popular
    matrix = @followers_matrix
    @users = @users.sort do |a, b|
      b.user_followers_count(matrix) <=> a.user_followers_count(matrix)
    end
  end

  def sort_friendly
    matrix = @followees_matrix
    @users = @users.sort do |a, b|
      b.user_followees_count(matrix) <=> a.user_followees_count(matrix)
    end
  end

  def sort_protagonists
    matrix = @opinions_matrix
    @users = @users.sort do |a, b|
      b.user_opinions_count(matrix) <=> a.user_opinions_count(matrix)
    end
  end
end
