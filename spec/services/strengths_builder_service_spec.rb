require 'rails_helper'

RSpec.describe StrengthsBuilderService do
  let(:user) { create(:user) }
  let(:resume) { create(:resume, user: user) }

  describe "#start_session" do
    before { stub_gemini_generate("AIの回答です") }

    it "creates an AI session" do
      service = described_class.new(user, resume)
      expect { service.start_session }.to change(AiSession, :count).by(1)
    end

    it "creates user and assistant messages" do
      service = described_class.new(user, resume)
      service.start_session
      expect(AiMessage.count).to eq(2)
      expect(AiMessage.first.user?).to be true
      expect(AiMessage.last.assistant?).to be true
    end

    it "sets correct session type" do
      service = described_class.new(user, resume)
      session = service.start_session
      expect(session.strengths_builder?).to be true
    end
  end

  describe "#send_message" do
    before { stub_gemini_generate("AIの回答です") }

    it "adds messages and generates response" do
      service = described_class.new(user, resume)
      service.start_session

      stub_gemini_generate("追加の回答です")
      service.send_message("追加の質問です")

      expect(AiMessage.count).to eq(4)
    end
  end
end
