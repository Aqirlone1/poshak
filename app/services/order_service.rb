class OrderService
  attr_reader :order

  def initialize(user:, cart:, shipping_address:, billing_address: nil)
    @user = user
    @cart = cart
    @shipping_address = shipping_address
    @billing_address = billing_address || shipping_address
  end

  def create_order
    ActiveRecord::Base.transaction do
      @order = @user.orders.build(
        order_number: generate_order_number,
        status: :pending,
        payment_method: "COD",
        payment_status: :pending,
        shipping_address: @shipping_address,
        billing_address: @billing_address
      )

      @cart.cart_items.includes(:product_variant).find_each do |cart_item|
        variant = cart_item.product_variant.lock!
        raise ActiveRecord::Rollback, "Not enough stock" if variant.stock_quantity < cart_item.quantity

        @order.order_items.build(
          product: cart_item.product,
          product_variant: variant,
          quantity: cart_item.quantity,
          unit_price: variant.final_price,
          total_price: variant.final_price * cart_item.quantity
        )
        variant.update!(stock_quantity: variant.stock_quantity - cart_item.quantity)
      end

      calculate_totals
      @order.save!
      @cart.cart_items.destroy_all
      # MVP deploy mode: send synchronously so Redis/worker is optional.
      OrderMailer.confirmation(@order).deliver_now
      { success: true, order: @order }
    rescue StandardError => e
      { success: false, error: e.message }
    end
  end

  private

  def generate_order_number
    "PK#{Time.current.strftime('%Y%m%d')}#{SecureRandom.hex(4).upcase}"
  end

  def calculate_totals
    @order.subtotal = @order.order_items.sum(&:total_price)
    @order.shipping_charge = @order.subtotal >= 1000 ? 0 : 50
    @order.tax_amount = (@order.subtotal * 0.18).round(2)
    @order.discount_amount = 0
    @order.total_amount = @order.subtotal + @order.shipping_charge + @order.tax_amount
  end
end
