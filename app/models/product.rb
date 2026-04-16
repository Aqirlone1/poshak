class Product < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :category
  has_many :product_variants, dependent: :destroy
  has_many :product_images, dependent: :destroy
  has_many :wishlists, dependent: :destroy
  has_many :order_items, dependent: :restrict_with_error

  enum :gender, { men: 0, women: 1, unisex: 2, kids: 3 }, default: :unisex

  validates :name, :price, :sku, presence: true
  validates :sku, uniqueness: true
  validates :slug, uniqueness: true, allow_blank: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :compare_at_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :active, -> { where(active: true) }
  scope :featured, -> { where(featured: true) }
  scope :ordered, -> { order(:position, created_at: :desc) }

  def primary_image
    product_images.includes(image_attachment: :blob).order(:position, :created_at).find { |img| img.image.attached? }
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      active
      brand
      care_instructions
      category_id
      compare_at_price
      created_at
      description
      featured
      gender
      id
      material
      name
      position
      price
      sku
      slug
      updated_at
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[category]
  end
end
