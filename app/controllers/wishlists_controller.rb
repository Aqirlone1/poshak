class WishlistsController < ApplicationController
  before_action :authenticate_user!

  def index
    @wishlists = current_user.wishlists.includes(:product).order(created_at: :desc)
  end

  def create
    wishlist = current_user.wishlists.new(product_id: params[:product_id])
    if wishlist.save
      redirect_back fallback_location: products_path, notice: "Added to wishlist."
    else
      redirect_back fallback_location: products_path, alert: wishlist.errors.full_messages.to_sentence
    end
  end

  def destroy
    current_user.wishlists.find(params[:id]).destroy
    redirect_back fallback_location: wishlists_path, notice: "Removed from wishlist."
  end
end
