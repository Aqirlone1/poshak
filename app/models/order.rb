class Order < ApplicationRecord
  belongs_to :user
  belongs_to :shipping_address, class_name: "Address"
  belongs_to :billing_address, class_name: "Address"
  has_many :order_items, dependent: :destroy

  enum :status, {
    pending: 0,
    confirmed: 1,
    processing: 2,
    shipped: 3,
    delivered: 4,
    cancelled: 5
  }, default: :pending

  enum :payment_status, { pending: 0, completed: 1, failed: 2 }, default: :pending, prefix: :payment

  validates :order_number, presence: true, uniqueness: true
  validates :payment_method, presence: true

  scope :recent, -> { order(created_at: :desc) }

  def cancellable?
    pending? || confirmed?
  end
end
