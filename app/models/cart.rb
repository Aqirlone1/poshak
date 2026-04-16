class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy

  validates :session_id, presence: true, unless: :user_id?

  def subtotal
    cart_items.includes(:product_variant).sum { |item| item.product_variant.final_price * item.quantity }
  end
end
