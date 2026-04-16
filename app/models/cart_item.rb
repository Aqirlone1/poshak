class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product
  belongs_to :product_variant

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validate :product_matches_variant

  def total_price
    product_variant.final_price * quantity
  end

  private

  def product_matches_variant
    return if product_id == product_variant&.product_id

    errors.add(:product_id, "must match selected variant product")
  end
end
