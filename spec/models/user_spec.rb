require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:resumes).dependent(:destroy) }
    it { should have_many(:ai_sessions).dependent(:destroy) }
    it { should have_many(:interview_preps).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_length_of(:display_name).is_at_most(50) }
  end

  describe "enums" do
    it { should define_enum_for(:career_stage).with_values(considering: 0, actively_looking: 1, interviewing: 2, offered: 3) }
  end
end
