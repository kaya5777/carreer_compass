require 'rails_helper'

RSpec.describe "Dashboard", type: :request do
  describe "GET /dashboard" do
    it "redirects unauthenticated users to sign in" do
      get dashboard_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "returns success for authenticated users" do
      user = create(:user)
      sign_in user
      get dashboard_path
      expect(response).to have_http_status(:success)
    end
  end
end
