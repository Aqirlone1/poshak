require "rails_helper"

RSpec.describe "User registrations", type: :request do
  it "persists first_name, last_name, and phone_number on sign up" do
    expect do
      post user_registration_path, params: {
        user: {
          email: "newuser@example.com",
          password: "password123",
          password_confirmation: "password123",
          first_name: "Jane",
          last_name: "Doe",
          phone_number: "1234567890"
        }
      }
    end.to change(User, :count).by(1)

    user = User.find_by!(email: "newuser@example.com")
    expect(user.first_name).to eq "Jane"
    expect(user.last_name).to eq "Doe"
    expect(user.phone_number).to eq "1234567890"
  end
end
