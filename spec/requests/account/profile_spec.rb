require 'rails_helper'

RSpec.describe "Account::Profiles", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/account/profile/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/account/profile/update"
      expect(response).to have_http_status(:success)
    end
  end

end
