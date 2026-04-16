require "rails_helper"

RSpec.describe Wishlist, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:product) }
  end

  describe "validations" do
    subject { create(:wishlist, user: create(:user), product: create(:product)) }

    it { is_expected.to validate_uniqueness_of(:product_id).scoped_to(:user_id) }
  end
end
