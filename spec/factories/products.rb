FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    description { "Premium product description" }
    price { 999.0 }
    compare_at_price { 1299.0 }
    sequence(:sku) { |n| "SKU#{n}" }
    association :category
    gender { :unisex }
    brand { "Poshak" }
    material { "Cotton" }
    care_instructions { "Machine wash cold" }
    active { true }
    featured { false }
    position { 1 }
  end
end
