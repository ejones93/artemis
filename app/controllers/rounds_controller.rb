class RoundsController < ApplicationController
  
  def index
    @rounds = Round.all
  end
  
  def show
    @round = Round.find(params[:id])
  end
  
  def print
    @round = Round.find(params[:id])
    render 'print', :layout => false
  end
  
end
