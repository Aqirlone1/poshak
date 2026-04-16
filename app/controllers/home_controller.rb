class HomeController < ApplicationController
  def index
    @featured_products = Product.active.featured.ordered.limit(8)
    @new_arrivals = Product.active.order(created_at: :desc).limit(8)
    @categories = Category.active.ordered.limit(6)
  end
end
