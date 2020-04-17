class RoundsController < ApplicationController
  before_action :logged_in_user, 	only: [:index, :show]
  
  def index
    @rounds = Round.paginate(page: params[:page])
  end
  
  def show
    @round = Round.find(params[:id])
  end
end
