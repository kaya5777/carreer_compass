require 'rails_helper'

RSpec.describe CompatibilityDiagnosisService do
  let(:user) { create(:user) }
  let(:interview_prep) { create(:interview_prep, user: user) }
  let(:resume) { create(:resume, user: user) }

  before { stub_gemini_generate("AIの回答です") }

  describe "#start_session" do
    it "creates an AI session" do
      service = described_class.new(user, interview_prep, resume)
      expect { service.start_session }.to change(AiSession, :count).by(1)
    end

    it "sets correct session type" do
      service = described_class.new(user, interview_prep, resume)
      session = service.start_session
      expect(session.compatibility_diagnosis?).to be true
    end

    it "works without resume" do
      service = described_class.new(user, interview_prep)
      session = service.start_session
      expect(session).to be_persisted
    end
  end
end
