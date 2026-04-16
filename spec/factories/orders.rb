FactoryBot.define do
  factory :order do
    sequence(:order_number) { |n| "ORD-#{n}" }
    association :user
    status { :pending }
    subtotal { "9.99" }
    shipping_charge { "9.99" }
    tax_amount { "9.99" }
    discount_amount { "9.99" }
    total_amount { "9.99" }
    payment_method { "COD" }
    payment_status { :pending }
    notes { "MyText" }
    association :shipping_address, factory: :address
    association :billing_address, factory: :address
    shipped_at { nil }
    delivered_at { nil }
    cancelled_at { nil }
  end
end
