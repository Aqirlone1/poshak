class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  enum :role, { customer: 0, admin: 1 }, default: :customer

  has_many :orders, dependent: :nullify
  has_many :addresses, dependent: :destroy
  has_many :wishlists, dependent: :destroy
  has_many :carts, dependent: :nullify

  validates :first_name, :last_name, presence: true
  validates :phone_number, length: { minimum: 10, maximum: 15 }, allow_blank: true

  def full_name
    "#{first_name} #{last_name}".strip
  end
end
