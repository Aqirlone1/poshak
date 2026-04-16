require 'rails_helper'

RSpec.describe "Checkouts", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/checkout/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /address" do
    it "returns http success" do
      get "/checkout/address"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /review" do
    it "returns http success" do
      get "/checkout/review"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /place_order" do
    it "returns http success" do
      get "/checkout/place_order"
      expect(response).to have_http_status(:success)
    end
  end

end
