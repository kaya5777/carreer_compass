require 'rails_helper'

RSpec.describe MockAnswer, type: :model do
  describe "associations" do
    it { should belong_to(:interview_question) }
    it { should belong_to(:ai_session) }
  end

  describe "validations" do
    it { should validate_presence_of(:user_answer) }
    it { should validate_numericality_of(:score).is_in(0..100).allow_nil }
  end
end
