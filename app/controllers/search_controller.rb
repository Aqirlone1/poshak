class SearchController < ApplicationController
  def index
    query = params[:q].to_s.strip
    @products = Product.active.includes(:category)
    if query.present?
      @products = @products.ransack(name_or_sku_or_category_name_cont: query).result(distinct: true)
    end
    @products = @products.ordered.page(params[:page]).per(12)
  end
end
