class CartsController < ApplicationController
  def show
    @cart_items = current_cart.cart_items.includes(:product, :product_variant).order(created_at: :desc)
  end

  def add_item
    variant = ProductVariant.find(params[:product_variant_id])
    result = CartService.new(current_cart).add_item(variant, params[:quantity] || 1)

    redirect_back fallback_location: cart_path, notice: result[:success] ? "Item added to cart." : nil,
                                 alert: (result[:error] unless result[:success])
  end

  def update_item
    cart_item = current_cart.cart_items.find(params[:cart_item_id])
    result = CartService.new(current_cart).update_item(cart_item, params[:quantity])
    redirect_to cart_path, notice: result[:success] ? "Cart updated." : nil, alert: (result[:error] unless result[:success])
  end

  def remove_item
    cart_item = current_cart.cart_items.find(params[:cart_item_id])
    cart_item.destroy
    redirect_to cart_path, notice: "Item removed from cart."
  end

  def destroy
    current_cart.cart_items.destroy_all
    redirect_to cart_path, notice: "Cart cleared."
  end
end
