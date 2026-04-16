class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :parent, class_name: "Category", optional: true
  has_many :children, class_name: "Category", foreign_key: :parent_id, dependent: :nullify, inverse_of: :parent
  has_many :products, dependent: :nullify

  validates :name, presence: true, uniqueness: true
  validates :slug, uniqueness: true, allow_blank: true

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:position, :name) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[active created_at description id name parent_id position slug updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[children parent products]
  end
end
