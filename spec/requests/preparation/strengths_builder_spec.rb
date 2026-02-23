require 'rails_helper'

RSpec.describe "Preparation::StrengthsBuilder", type: :request do
  let(:user) { create(:user) }
  let(:resume) { create(:resume, user: user) }

  before do
    sign_in user
    stub_gemini_generate("AIの回答です")
  end

  describe "GET /preparation/strengths_builder" do
    it "returns success" do
      get preparation_strengths_builder_index_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /preparation/strengths_builder" do
    it "creates a session and redirects" do
      post preparation_strengths_builder_index_path, params: { resume_id: resume.id }
      expect(AiSession.count).to eq(1)
      expect(response).to redirect_to(preparation_strengths_builder_path(AiSession.last))
    end
  end

  describe "GET /preparation/strengths_builder/:id" do
    it "returns success" do
      service = StrengthsBuilderService.new(user, resume)
      session = service.start_session
      get preparation_strengths_builder_path(session)
      expect(response).to have_http_status(:success)
    end
  end
end
