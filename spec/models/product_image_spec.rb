require "rails_helper"

RSpec.describe ProductImage, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:product) }
    it { is_expected.to have_one_attached(:image) }
  end

  describe "validations" do
    subject { build(:product_image, product: create(:product)) }

    it { is_expected.to validate_presence_of(:image) }
    it { is_expected.to validate_numericality_of(:position).is_greater_than_or_equal_to(0).allow_nil }
  end
end
