class AiMessage < ApplicationRecord
  belongs_to :ai_session

  enum :role, {
    user: 0,
    assistant: 1
  }

  validates :content, presence: true
  validates :role, presence: true

  scope :chronological, -> { order(created_at: :asc) }
end
