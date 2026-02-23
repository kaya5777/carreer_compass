class MockAnswer < ApplicationRecord
  belongs_to :interview_question
  belongs_to :ai_session

  validates :user_answer, presence: true
  validates :score, numericality: { in: 0..100 }, allow_nil: true
end
