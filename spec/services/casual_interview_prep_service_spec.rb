require 'rails_helper'

RSpec.describe CasualInterviewPrepService do
  let(:user) { create(:user) }
  let(:interview_prep) { create(:interview_prep, user: user) }

  before { stub_gemini_generate("AIの回答です") }

  describe "#start_session" do
    it "creates an AI session" do
      service = described_class.new(user, interview_prep)
      expect { service.start_session }.to change(AiSession, :count).by(1)
    end

    it "sets correct session type" do
      service = described_class.new(user, interview_prep)
      session = service.start_session
      expect(session.casual_interview_prep?).to be true
    end

    it "works without interview_prep" do
      service = described_class.new(user)
      session = service.start_session
      expect(session.title).to eq("カジュアル面談対策")
    end
  end

  describe "#send_message" do
    it "adds messages and generates response" do
      service = described_class.new(user, interview_prep)
      service.start_session

      stub_gemini_generate("追加の回答です")
      service.send_message("追加の質問です")

      expect(AiMessage.count).to eq(4)
    end
  end
end
