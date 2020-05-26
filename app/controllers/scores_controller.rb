class ScoresController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :admin_user,     only: :destroy
  
  def create
    @score = current_user.scores.build(score_params)
    @score.image.attach(params[:score][:image])
    if @score.save
      flash[:success] = "Score submitted!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end
  
  def destroy
    user = Score.find(params[:id]).user
    Score.find(params[:id]).destroy
    user.update_all_bowtypes
    flash[:success] = "Score deleted"
    redirect_back(fallback_location: root_url)
  end
  
  private
    def score_params
      params.require(:score).permit(:date, :round_id, :bowtype, :score, :hits, :golds, :xs, :location, :record_status,  :comment, :image)
    end
    
    # Confirms an admin user
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  # End of private
end
