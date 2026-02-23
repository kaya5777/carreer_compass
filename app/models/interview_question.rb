class InterviewQuestion < ApplicationRecord
  belongs_to :interview_prep
  has_many :mock_answers, dependent: :destroy

  enum :category, {
    self_introduction: 0,
    motivation: 1,
    experience: 2,
    technical: 3,
    behavioral: 4,
    company_specific: 5,
    future_goals: 6
  }

  enum :difficulty, {
    easy: 0,
    medium: 1,
    hard: 2
  }

  validates :question_text, presence: true
end
