require 'rails_helper'

RSpec.describe "Preparation::ResumeReview", type: :request do
  let(:user) { create(:user) }
  let(:resume) { create(:resume, user: user, personal_summary: "テストサマリー", work_history: "テスト経歴", skills: "Ruby") }

  before do
    sign_in user
    stub_gemini_generate("AIの回答です")
  end

  describe "GET /preparation/resume_review" do
    it "returns success" do
      get preparation_resume_review_index_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /preparation/resume_review" do
    it "creates a session and redirects" do
      post preparation_resume_review_index_path, params: { resume_id: resume.id }
      expect(AiSession.count).to eq(1)
      expect(response).to redirect_to(preparation_resume_review_path(AiSession.last))
    end
  end

  describe "GET /preparation/resume_review/:id" do
    it "returns success" do
      service = ResumeReviewService.new(user, resume)
      session = service.start_session
      get preparation_resume_review_path(session)
      expect(response).to have_http_status(:success)
    end
  end
end
