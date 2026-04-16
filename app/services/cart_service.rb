class CartService
  def initialize(cart)
    @cart = cart
  end

  def add_item(product_variant, quantity = 1)
    item = @cart.cart_items.find_or_initialize_by(product_variant: product_variant, product: product_variant.product)
    item.quantity = (item.quantity || 0) + quantity.to_i

    return { success: false, error: "Not enough stock" } if item.quantity > product_variant.stock_quantity

    if item.save
      { success: true, cart_item: item }
    else
      { success: false, error: item.errors.full_messages.to_sentence }
    end
  end

  def update_item(cart_item, quantity)
    quantity = quantity.to_i
    return cart_item.destroy && { success: true } if quantity <= 0
    return { success: false, error: "Not enough stock" } if quantity > cart_item.product_variant.stock_quantity

    if cart_item.update(quantity: quantity)
      { success: true, cart_item: cart_item }
    else
      { success: false, error: cart_item.errors.full_messages.to_sentence }
    end
  end
end
