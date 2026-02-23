require 'rails_helper'

RSpec.describe AiResponseJob, type: :job do
  let(:user) { create(:user) }
  let(:ai_session) { create(:ai_session, user: user, session_type: :strengths_builder) }

  before { stub_gemini_generate("AI回答") }

  describe "#perform" do
    it "generates AI response and creates message" do
      ai_session.ai_messages.create!(role: :user, content: "質問です")

      expect {
        described_class.perform_now(ai_session.id)
      }.to change { ai_session.ai_messages.count }.by(1)
    end

    it "creates assistant message" do
      ai_session.ai_messages.create!(role: :user, content: "質問です")
      described_class.perform_now(ai_session.id)

      expect(ai_session.ai_messages.last.assistant?).to be true
    end
  end
end
