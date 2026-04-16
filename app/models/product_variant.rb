class ProductVariant < ApplicationRecord
  belongs_to :product

  has_many :cart_items, dependent: :restrict_with_error
  has_many :order_items, dependent: :restrict_with_error

  validates :size, :color, :sku, presence: true
  validates :sku, uniqueness: true
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :additional_price, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(active: true) }

  def final_price
    product.price + additional_price
  end
end
