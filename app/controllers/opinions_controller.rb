class OpinionsController < ApplicationController
  before_action :set_opinion, only: %i[show update destroy edit]
  before_action :require_login

  def index
    @direction = 'root'
    @opinion = Opinion.new
    @opinions = Opinion.all.includes({ author: :photo_blob }).ordered_by_most_recent

    @likes = Like.all

    @current_user = User.includes(:photo_blob, :followed, :followers).find(session[:user_id])
    @followers_matrix = User.popular_matrix
    @followees_matrix = User.friendly_matrix
    @to_follow = User.all.where('id NOT IN (?)', User.user_followed(@current_user)).includes(:photo_blob)
  end

  def new
    @opinion = Opinion.new
  end

  def create
    @opinion = Opinion.new(opinion_params)
    @opinion.author_id = session[:user_id]

    flash[:alert] = @opinion.errors.full_messages unless @opinion.save

    redirect_to opinions_path
  end

  def update
    if @opinion.update(opinion_params)
      redirect_to opinions_path
    else
      redirect_to edit_opinion_path(params[:id])
    end
  end

  def destroy
    @opinion.destroy
    respond_to do |format|
      format.html { redirect_to opinions_url, notice: 'Opinion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_opinion
    @opinion = Opinion.find(params[:id])
  end

  def opinion_params
    params.require(:opinion).permit(:text)
  end
end
