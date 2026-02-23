require 'rails_helper'

RSpec.describe "Preparation::CasualInterviewPrep", type: :request do
  let(:user) { create(:user) }
  let(:interview_prep) { create(:interview_prep, user: user) }

  before do
    sign_in user
    stub_gemini_generate("AIの回答です")
  end

  describe "GET /preparation/casual_interview_prep" do
    it "returns success" do
      get preparation_casual_interview_prep_index_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /preparation/casual_interview_prep" do
    it "creates a session and redirects" do
      post preparation_casual_interview_prep_index_path, params: { interview_prep_id: interview_prep.id }
      expect(AiSession.count).to eq(1)
      expect(response).to redirect_to(preparation_casual_interview_prep_path(AiSession.last))
    end
  end

  describe "GET /preparation/casual_interview_prep/:id" do
    it "returns success" do
      service = CasualInterviewPrepService.new(user, interview_prep)
      session = service.start_session
      get preparation_casual_interview_prep_path(session)
      expect(response).to have_http_status(:success)
    end
  end
end
