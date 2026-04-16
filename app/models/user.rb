class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  # Without SMTP on production (Render, etc.), confirmation emails cannot be delivered; Devise would
  # leave users unconfirmed (cannot sign in) or raise on delivery. Skip email flow when SMTP is unset.
  before_create :confirm_without_email_if_smtp_missing

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

  private

  def confirm_without_email_if_smtp_missing
    return unless Rails.env.production?
    return if ENV["SMTP_USERNAME"].present? && ENV["SMTP_PASSWORD"].present?

    self.confirmed_at = Time.zone.now
    skip_confirmation_notification!
  end
end
