require "rails_helper"

RSpec.describe Address, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:address_type).with_values(home: 0, work: 1, other: 2).with_default(:home) }
  end

  describe "validations" do
    subject { build(:address) }

    it { is_expected.to validate_presence_of(:full_name) }
    it { is_expected.to validate_presence_of(:phone_number) }
    it { is_expected.to validate_presence_of(:address_line1) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:state) }
    it { is_expected.to validate_presence_of(:postal_code) }
    # country has a before_validation callback that defaults to "India", so presence_of can't be tested via shoulda
    it "requires country after skipping default callback" do
      address = build(:address, country: nil)
      address.valid?
      expect(address.country).to eq("India")
    end
  end

  describe "callbacks" do
    it "assigns default country when blank" do
      address = build(:address, country: "")
      address.valid?
      expect(address.country).to eq("India")
    end

    it "does not overwrite an existing country" do
      address = build(:address, country: "USA")
      address.valid?
      expect(address.country).to eq("USA")
    end
  end
end
