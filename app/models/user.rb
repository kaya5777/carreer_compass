class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
      user.email = auth.info.email
      user.display_name = auth.info.name
      user.password = Devise.friendly_token[0, 20]
    end.tap(&:save!)
  end

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
