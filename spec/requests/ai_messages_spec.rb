require 'rails_helper'

RSpec.describe "AiMessages", type: :request do
  let(:user) { create(:user) }
  let(:ai_session) { create(:ai_session, user: user, session_type: :strengths_builder) }

  before do
    sign_in user
    stub_gemini_generate("AI回答です")
  end

  describe "POST /ai_messages/send_message" do
    it "sends a message and gets AI response" do
      post send_message_path, params: { ai_session_id: ai_session.id, content: "テストメッセージ" }, as: :turbo_stream
      expect(response).to have_http_status(:success)
      expect(ai_session.ai_messages.count).to eq(2)
    end

    it "rejects blank content" do
      post send_message_path, params: { ai_session_id: ai_session.id, content: "" }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "prevents access to other user's session" do
      other_session = create(:ai_session)
      post send_message_path, params: { ai_session_id: other_session.id, content: "test" }
      expect(response).to have_http_status(:not_found)
    end
  end
end
