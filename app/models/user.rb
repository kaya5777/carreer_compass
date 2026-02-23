class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :resumes, dependent: :destroy
  has_many :ai_sessions, dependent: :destroy
  has_many :interview_preps, dependent: :destroy

  enum :career_stage, {
    considering: 0,
    actively_looking: 1,
    interviewing: 2,
    offered: 3
  }

  validates :display_name, length: { maximum: 50 }
end
