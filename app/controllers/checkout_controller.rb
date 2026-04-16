class CheckoutController < ApplicationController
  before_action :authenticate_user!, except: :show

  def show
    @cart_items = current_cart.cart_items.includes(:product_variant, :product)
    redirect_to cart_path, alert: "Your cart is empty." if @cart_items.empty?
  end

  def address
    load_address_step
  end

  def create_address
    @address = current_user.addresses.new(address_params)
    if @address.save
      session[:checkout_shipping_address_id] = @address.id
      session[:checkout_billing_address_id] = @address.id
      redirect_to checkout_review_path, notice: "Address added."
    else
      load_address_step
      render :address, status: :unprocessable_entity
    end
  end

  def review
    if request.post?
      @shipping_address = current_user.addresses.find(params[:shipping_address_id])
      @billing_address = params[:billing_address_id].present? ? current_user.addresses.find(params[:billing_address_id]) : @shipping_address
      session[:checkout_shipping_address_id] = @shipping_address.id
      session[:checkout_billing_address_id] = @billing_address.id
      return redirect_to checkout_review_path
    end

    if session[:checkout_shipping_address_id].blank?
      return redirect_to checkout_address_path, alert: "Please select a shipping address."
    end

    @shipping_address = current_user.addresses.find(session[:checkout_shipping_address_id])
    @billing_address = current_user.addresses.find(session[:checkout_billing_address_id])
    @cart_items = current_cart.cart_items.includes(:product_variant, :product)
  end

  def place_order
    shipping_address = current_user.addresses.find(session[:checkout_shipping_address_id])
    billing_address = current_user.addresses.find(session[:checkout_billing_address_id])
    result = OrderService.new(user: current_user, cart: current_cart, shipping_address: shipping_address, billing_address: billing_address).create_order

    if result[:success]
      redirect_to account_order_path(result[:order]), notice: "Order placed successfully."
    else
      redirect_to checkout_path, alert: result[:error]
    end
  end

  private

  def load_address_step
    @addresses = current_user.addresses.order(is_default: :desc, created_at: :desc)
    @selected_shipping_id = session[:checkout_shipping_address_id]
    @address = current_user.addresses.new
  end

  def address_params
    params.require(:address).permit(:address_type, :full_name, :phone_number, :address_line1, :address_line2, :city, :state,
                                    :postal_code, :country, :is_default)
  end
end
