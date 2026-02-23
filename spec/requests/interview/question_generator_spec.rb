require 'rails_helper'

RSpec.describe "Interview::QuestionGenerator", type: :request do
  let(:user) { create(:user) }
  let(:interview_prep) { create(:interview_prep, user: user) }

  before do
    sign_in user
    stub_gemini_generate("AIの回答です")
  end

  describe "GET /interview/question_generator" do
    it "returns success" do
      get interview_question_generator_index_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /interview/question_generator" do
    it "creates a session and redirects" do
      post interview_question_generator_index_path, params: { interview_prep_id: interview_prep.id }
      expect(AiSession.count).to eq(1)
      expect(response).to redirect_to(interview_question_generator_path(AiSession.last))
    end
  end

  describe "GET /interview/question_generator/:id" do
    it "returns success" do
      service = QuestionGeneratorService.new(user, interview_prep)
      session = service.start_session
      get interview_question_generator_path(session)
      expect(response).to have_http_status(:success)
    end
  end
end
