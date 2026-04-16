FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    first_name { "Aqir" }
    last_name { "User" }
    phone_number { "9999999999" }
    role { :customer }
    password { "password123" }
    password_confirmation { "password123" }
    confirmed_at { Time.current }
  end
end
