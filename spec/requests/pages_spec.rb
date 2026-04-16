require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /about" do
    it "returns http success" do
      get "/pages/about"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /contact" do
    it "returns http success" do
      get "/pages/contact"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create_contact" do
    it "returns http success" do
      get "/pages/create_contact"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /size_guide" do
    it "returns http success" do
      get "/pages/size_guide"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /shipping" do
    it "returns http success" do
      get "/pages/shipping"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /returns" do
    it "returns http success" do
      get "/pages/returns"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /privacy" do
    it "returns http success" do
      get "/pages/privacy"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /terms" do
    it "returns http success" do
      get "/pages/terms"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /faq" do
    it "returns http success" do
      get "/pages/faq"
      expect(response).to have_http_status(:success)
    end
  end

end
