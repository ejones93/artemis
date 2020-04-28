class CategoriesController < ApplicationController
  def index
    @categories = Category
  end

  def show
    @category = Category.find(params[:id]) 
  end
end
