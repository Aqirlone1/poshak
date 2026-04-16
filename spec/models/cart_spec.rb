require "rails_helper"

RSpec.describe Cart, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user).optional }
    it { is_expected.to have_many(:cart_items).dependent(:destroy) }
  end

  describe "validations" do
    context "when user is present" do
      subject { build(:cart, user: create(:user), session_id: nil) }

      it { is_expected.to be_valid }
    end

    context "when user is absent" do
      subject { build(:cart, user: nil, session_id: nil) }

      it "requires session_id" do
        expect(subject).not_to be_valid
        expect(subject.errors[:session_id]).to include("can't be blank")
      end
    end

    context "when user is absent but session_id is present" do
      subject { build(:cart, user: nil, session_id: "abc123") }

      it { is_expected.to be_valid }
    end
  end
end
