require "rails_helper"

RSpec.describe Product, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_many(:product_variants) }
    it { is_expected.to have_many(:product_images) }
  end

  describe "validations" do
    subject(:product) { build(:product) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_presence_of(:sku) }
    it { is_expected.to validate_uniqueness_of(:sku) }
  end

  describe "scopes" do
    it "returns only active products" do
      active = create(:product, active: true)
      inactive = create(:product, active: false)

      expect(Product.active).to include(active)
      expect(Product.active).not_to include(inactive)
    end
  end
end
