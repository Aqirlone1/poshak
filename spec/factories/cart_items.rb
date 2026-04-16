FactoryBot.define do
  factory :cart_item do
    association :cart
    association :product
    product_variant { association :product_variant, product: product }
    quantity { 1 }
  end
end
