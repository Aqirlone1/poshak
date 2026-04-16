require "rails_helper"

RSpec.describe "Checkout process", type: :feature do
  let(:user) { create(:user) }
  let(:product) { create(:product) }
  let(:variant) { create(:product_variant, product: product, stock_quantity: 5) }
  let!(:address) do
    create(:address, user: user, full_name: "Aqir User", phone_number: "9999999999", address_line1: "123 Main St",
                     city: "Mumbai", state: "MH", postal_code: "400001", country: "India")
  end

  it "completes order with COD" do
    login_as(user, scope: :user)
    visit product_path(product)
    select "#{variant.size} / #{variant.color} (#{variant.stock_quantity} left)", from: "product_variant_id"
    click_button "Add to Cart"

    visit checkout_path
    click_button "Continue to Address"
    choose(option: address.id.to_s)
    click_button "Continue to Review"
    click_button "Place COD Order"

    expect(page).to have_content("Order placed successfully")
    expect(Order.last.payment_method).to eq("COD")
  end
end
