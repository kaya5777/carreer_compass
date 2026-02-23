class Resume < ApplicationRecord
  include EnumI18n

  belongs_to :user
  has_many :ai_sessions, as: :sessionable, dependent: :destroy
  has_many :interview_preps, dependent: :destroy

  enum :status, {
    draft: 0,
    in_progress: 1,
    completed: 2
  }

  validates :title, presence: true, length: { maximum: 100 }

  def status_i18n
    enum_i18n(:status)
  end
end
