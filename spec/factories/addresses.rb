FactoryBot.define do
  factory :address do
    association :user
    address_type { :home }
    full_name { "Aqir User" }
    phone_number { "9999999999" }
    address_line1 { "123 Main Street" }
    address_line2 { "Apt 5" }
    city { "Mumbai" }
    state { "MH" }
    postal_code { "400001" }
    country { "India" }
    is_default { false }
  end
end
