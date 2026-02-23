require 'rails_helper'

RSpec.describe AiSession, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:sessionable).optional }
    it { should have_many(:ai_messages).dependent(:destroy) }
    it { should have_many(:mock_answers).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(200) }
  end

  describe "enums" do
    it { should define_enum_for(:session_type).with_values(strengths_builder: 0, resume_review: 1, casual_interview_prep: 2, question_generator: 3, mock_interview: 4, compatibility_diagnosis: 5) }
    it { should define_enum_for(:status).with_values(active: 0, completed: 1, archived: 2) }
  end

  describe "scopes" do
    it "orders by updated_at desc" do
      old_session = create(:ai_session, updated_at: 1.day.ago)
      new_session = create(:ai_session, updated_at: 1.hour.ago)
      expect(AiSession.recent).to eq([new_session, old_session])
    end
  end
end
