require "rails_helper"

RSpec.describe CartItem, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:cart) }
    it { is_expected.to belong_to(:product) }
    it { is_expected.to belong_to(:product_variant) }
  end

  describe "validations" do
    subject { build(:cart_item) }

    it { is_expected.to validate_numericality_of(:quantity).only_integer.is_greater_than(0) }
  end

  describe "product_matches_variant" do
    let(:product) { create(:product) }
    let(:other_product) { create(:product) }
    let(:variant) { create(:product_variant, product: product) }
    let(:cart) { create(:cart) }

    it "is valid when product matches the variant's product" do
      cart_item = build(:cart_item, cart: cart, product: product, product_variant: variant)
      expect(cart_item).to be_valid
    end

    it "is invalid when product does not match the variant's product" do
      cart_item = build(:cart_item, cart: cart, product: other_product, product_variant: variant)
      expect(cart_item).not_to be_valid
      expect(cart_item.errors[:product_id]).to include("must match selected variant product")
    end
  end
end
