class ProductsController < ApplicationController
  def index
    @q = policy_scope(Product).includes(:category, :product_images, :product_variants).ransack(params[:q])
    @products = @q.result(distinct: true).ordered.page(params[:page]).per(12)

    @products = @products.where(gender: params[:gender]) if params[:gender].present?
    @products = @products.where("price >= ?", params[:min_price]) if params[:min_price].present?
    @products = @products.where("price <= ?", params[:max_price]) if params[:max_price].present?
  end

  def show
    @product = Product.friendly.find(params[:id])
    authorize @product
    @variants = @product.product_variants.active.order(:size, :color)
    @related_products = @product.category.products.active.where.not(id: @product.id).limit(4)
  end
end
