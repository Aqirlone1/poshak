require "rails_helper"

RSpec.describe Category, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:parent).class_name("Category").optional }
    it { is_expected.to have_many(:children).class_name("Category").with_foreign_key(:parent_id).dependent(:nullify).inverse_of(:parent) }
    it { is_expected.to have_many(:products).dependent(:nullify) }
  end

  describe "validations" do
    subject { build(:category) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_uniqueness_of(:slug).allow_blank }
  end

  describe "scopes" do
    let!(:active_category) { create(:category, active: true) }
    let!(:inactive_category) { create(:category, active: false) }

    describe ".active" do
      it "returns only active categories" do
        expect(described_class.active).to include(active_category)
        expect(described_class.active).not_to include(inactive_category)
      end
    end

    describe ".ordered" do
      let!(:second) { create(:category, position: 2, name: "Zebra") }
      let!(:first) { create(:category, position: 1, name: "Alpha") }

      it "orders by position then name" do
        expect(described_class.ordered.first).to eq(first)
      end
    end
  end
end
