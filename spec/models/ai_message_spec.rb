require 'rails_helper'

RSpec.describe AiMessage, type: :model do
  describe "associations" do
    it { should belong_to(:ai_session) }
  end

  describe "validations" do
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:role) }
  end

  describe "enums" do
    it { should define_enum_for(:role).with_values(user: 0, assistant: 1) }
  end

  describe "scopes" do
    it "orders chronologically" do
      session = create(:ai_session)
      old_msg = create(:ai_message, ai_session: session, created_at: 1.hour.ago)
      new_msg = create(:ai_message, ai_session: session, created_at: 1.minute.ago)
      expect(session.ai_messages.chronological).to eq([old_msg, new_msg])
    end
  end
end
