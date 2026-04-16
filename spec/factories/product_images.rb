FactoryBot.define do
  factory :product_image do
    association :product
    position { 1 }
    alt_text { "Product photo" }

    after(:build) do |product_image|
      product_image.image.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/test_image.png")),
        filename: "test_image.png",
        content_type: "image/png"
      )
    end
  end
end
