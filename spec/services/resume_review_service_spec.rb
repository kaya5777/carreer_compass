require 'rails_helper'

RSpec.describe ResumeReviewService do
  let(:user) { create(:user) }
  let(:resume) { create(:resume, user: user, personal_summary: "経験豊富なエンジニアです") }

  describe "#start_session" do
    before { stub_gemini_generate("レビュー結果です") }

    it "creates a review session" do
      service = described_class.new(user, resume)
      session = service.start_session
      expect(session.resume_review?).to be true
      expect(session.title).to include("レビュー")
    end

    it "includes resume content in initial message" do
      service = described_class.new(user, resume)
      service.start_session
      first_message = AiMessage.first
      expect(first_message.content).to include("経験豊富なエンジニアです")
    end
  end
end
