require 'rails_helper'

RSpec.describe QuestionGeneratorService do
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
      expect(session.question_generator?).to be true
    end

    it "includes company name in title" do
      service = described_class.new(user, interview_prep)
      session = service.start_session
      expect(session.title).to include(interview_prep.company_name)
    end
  end
end
