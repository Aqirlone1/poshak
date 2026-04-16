FactoryBot.define do
  factory :product_variant do
    association :product
    size { "M" }
    color { "Black" }
    stock_quantity { 10 }
    sequence(:sku) { |n| "VSKU#{n}" }
    additional_price { 0 }
    active { true }
  end
end
