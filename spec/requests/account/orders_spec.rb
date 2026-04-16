require 'rails_helper'

RSpec.describe "Account::Orders", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/account/orders/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/account/orders/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /cancel" do
    it "returns http success" do
      get "/account/orders/cancel"
      expect(response).to have_http_status(:success)
    end
  end

end
