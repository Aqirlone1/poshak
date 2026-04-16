FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    description { "Category description" }
    parent { nil }
    position { 1 }
    active { true }
  end
end
