FactoryBot.define do
  factory :order_item do
    association :order
    association :product
    product_variant { association :product_variant, product: product }
    quantity { 1 }
    unit_price { "9.99" }
    total_price { "9.99" }
  end
end
