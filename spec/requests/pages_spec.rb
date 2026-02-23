require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /" do
    it "returns success for unauthenticated users" do
      get root_path
      expect(response).to have_http_status(:success)
    end

    it "redirects authenticated users to dashboard" do
      user = create(:user)
      sign_in user
      get root_path
      expect(response).to redirect_to(dashboard_path)
    end
  end
end
