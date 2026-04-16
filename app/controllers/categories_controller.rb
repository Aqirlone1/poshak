class CategoriesController < ApplicationController
  def index
    @categories = Category.active.includes(:children).ordered
  end

  def show
    @category = Category.friendly.find(params[:id])
    @products = @category.products.active.ordered.page(params[:page]).per(12)
  end
end
