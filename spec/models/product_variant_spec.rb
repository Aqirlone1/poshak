require "rails_helper"

RSpec.describe ProductVariant, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:product) }
    it { is_expected.to have_many(:cart_items).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:order_items).dependent(:restrict_with_error) }
  end

  describe "validations" do
    subject { build(:product_variant) }

    it { is_expected.to validate_presence_of(:size) }
    it { is_expected.to validate_presence_of(:color) }
    it { is_expected.to validate_presence_of(:sku) }
    it { is_expected.to validate_uniqueness_of(:sku) }
    it { is_expected.to validate_numericality_of(:stock_quantity).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:additional_price).is_greater_than_or_equal_to(0) }
  end

  describe "scopes" do
    describe ".active" do
      let!(:active_variant) { create(:product_variant, active: true) }
      let!(:inactive_variant) { create(:product_variant, active: false) }

      it "returns only active variants" do
        expect(described_class.active).to include(active_variant)
        expect(described_class.active).not_to include(inactive_variant)
      end
    end
  end

  describe "#final_price" do
    it "returns product price plus additional_price" do
      product = create(:product, price: 500.0)
      variant = build(:product_variant, product: product, additional_price: 100.0)
      expect(variant.final_price).to eq(600.0)
    end

    it "equals product price when additional_price is zero" do
      product = create(:product, price: 999.0)
      variant = build(:product_variant, product: product, additional_price: 0)
      expect(variant.final_price).to eq(999.0)
    end
  end
end
