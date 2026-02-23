require 'rails_helper'

RSpec.describe "Interview::CompatibilityDiagnosis", type: :request do
  let(:user) { create(:user) }
  let(:interview_prep) { create(:interview_prep, user: user) }
  let(:resume) { create(:resume, user: user) }

  before do
    sign_in user
    stub_gemini_generate("AIの回答です")
  end

  describe "GET /interview/compatibility_diagnosis" do
    it "returns success" do
      get interview_compatibility_diagnosis_index_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /interview/compatibility_diagnosis" do
    it "creates a session and redirects" do
      post interview_compatibility_diagnosis_index_path, params: { interview_prep_id: interview_prep.id, resume_id: resume.id }
      expect(AiSession.count).to eq(1)
      expect(response).to redirect_to(interview_compatibility_diagnosis_path(AiSession.last))
    end
  end

  describe "GET /interview/compatibility_diagnosis/:id" do
    it "returns success" do
      service = CompatibilityDiagnosisService.new(user, interview_prep, resume)
      session = service.start_session
      get interview_compatibility_diagnosis_path(session)
      expect(response).to have_http_status(:success)
    end
  end
end
