require "rails_helper"

RSpec.describe User, type: :model do
  describe "devise modules" do
    it { is_expected.to respond_to(:valid_password?) }

    it "includes expected Devise modules" do
      expected_modules = %i[database_authenticatable registerable recoverable rememberable validatable confirmable]
      expect(User.devise_modules).to match_array(expected_modules)
    end
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:role).with_values(customer: 0, admin: 1).with_default(:customer) }
  end

  describe "associations" do
    it { is_expected.to have_many(:orders).dependent(:nullify) }
    it { is_expected.to have_many(:addresses).dependent(:destroy) }
    it { is_expected.to have_many(:wishlists).dependent(:destroy) }
    it { is_expected.to have_many(:carts).dependent(:nullify) }
  end

  describe "validations" do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_length_of(:phone_number).is_at_least(10).is_at_most(15).allow_blank }
  end

  describe "#full_name" do
    it "returns first and last name joined" do
      user = build(:user, first_name: "Aqir", last_name: "Patel")
      expect(user.full_name).to eq("Aqir Patel")
    end

    it "strips trailing whitespace when last_name is blank" do
      user = build(:user, first_name: "Aqir", last_name: "")
      expect(user.full_name).to eq("Aqir")
    end
  end
end
