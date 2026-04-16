require "rails_helper"

RSpec.describe Order, type: :model do
  describe "enums" do
    it do
      is_expected.to define_enum_for(:status)
        .with_values(pending: 0, confirmed: 1, processing: 2, shipped: 3, delivered: 4, cancelled: 5)
        .with_default(:pending)
    end

    it do
      is_expected.to define_enum_for(:payment_status)
        .with_values(pending: 0, completed: 1, failed: 2)
        .with_default(:pending)
        .with_prefix(:payment)
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:shipping_address).class_name("Address") }
    it { is_expected.to belong_to(:billing_address).class_name("Address") }
    it { is_expected.to have_many(:order_items).dependent(:destroy) }
  end

  describe "validations" do
    subject { build(:order) }

    it { is_expected.to validate_presence_of(:order_number) }
    it { is_expected.to validate_uniqueness_of(:order_number) }
    it { is_expected.to validate_presence_of(:payment_method) }
  end

  describe "scopes" do
    describe ".recent" do
      let!(:older) { create(:order, created_at: 2.days.ago) }
      let!(:newer) { create(:order, created_at: 1.day.ago) }

      it "orders by created_at descending" do
        expect(described_class.recent.first).to eq(newer)
      end
    end
  end

  describe "#cancellable?" do
    it "is cancellable when pending" do
      order = build(:order, status: :pending)
      expect(order.cancellable?).to be true
    end

    it "is cancellable when confirmed" do
      order = build(:order, status: :confirmed)
      expect(order.cancellable?).to be true
    end

    it "is not cancellable when processing" do
      order = build(:order, status: :processing)
      expect(order.cancellable?).to be false
    end

    it "is not cancellable when shipped" do
      order = build(:order, status: :shipped)
      expect(order.cancellable?).to be false
    end

    it "is not cancellable when delivered" do
      order = build(:order, status: :delivered)
      expect(order.cancellable?).to be false
    end

    it "is not cancellable when already cancelled" do
      order = build(:order, status: :cancelled)
      expect(order.cancellable?).to be false
    end
  end
end
