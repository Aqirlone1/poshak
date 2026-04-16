class Address < ApplicationRecord
  belongs_to :user

  enum :address_type, { home: 0, work: 1, other: 2 }, default: :home

  validates :full_name, :phone_number, :address_line1, :city, :state, :postal_code, :country, presence: true

  before_validation :assign_default_country

  private

  def assign_default_country
    self.country = "India" if country.blank?
  end
end
