class AiSession < ApplicationRecord
  include EnumI18n

  belongs_to :user
  belongs_to :sessionable, polymorphic: true, optional: true
  has_many :ai_messages, dependent: :destroy
  has_many :mock_answers, dependent: :destroy

  enum :session_type, {
    strengths_builder: 0,
    resume_review: 1,
    casual_interview_prep: 2,
    question_generator: 3,
    mock_interview: 4,
    compatibility_diagnosis: 5
  }

  enum :status, {
    active: 0,
    completed: 1,
    archived: 2
  }

  validates :title, presence: true, length: { maximum: 200 }

  scope :recent, -> { order(updated_at: :desc) }

  def session_type_i18n
    enum_i18n(:session_type)
  end

  def status_i18n
    enum_i18n(:status)
  end
end
