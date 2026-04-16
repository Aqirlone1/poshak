FactoryBot.define do
  factory :wishlist do
    association :user
    association :product
  end
end
