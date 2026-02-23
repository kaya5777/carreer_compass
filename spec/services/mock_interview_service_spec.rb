require 'rails_helper'

RSpec.describe MockInterviewService do
  let(:user) { create(:user) }
  let(:interview_prep) { create(:interview_prep, user: user) }

  describe "#start_session" do
    before { stub_gemini_generate("面接を始めましょう") }

    it "creates a mock interview session" do
      service = described_class.new(user, interview_prep)
      session = service.start_session
      expect(session.mock_interview?).to be true
      expect(session.title).to include("模擬面接")
    end
  end
end
