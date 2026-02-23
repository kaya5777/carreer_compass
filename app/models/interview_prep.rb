class InterviewPrep < ApplicationRecord
  include EnumI18n

  belongs_to :user
  belongs_to :resume, optional: true
  has_many :interview_questions, dependent: :destroy
  has_many :ai_sessions, as: :sessionable, dependent: :destroy

  enum :interview_type, {
    casual: 0,
    first_round: 1,
    technical: 2,
    final_round: 3
  }

  enum :status, {
    draft: 0,
    in_progress: 1,
    completed: 2
  }

  validates :company_name, presence: true, length: { maximum: 100 }

  def status_i18n
    enum_i18n(:status)
  end

  def interview_type_i18n
    enum_i18n(:interview_type)
  end
end
