class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first
    user ||= find_by(email: auth.info.email)
    user ||= new(email: auth.info.email, display_name: auth.info.name, password: Devise.friendly_token[0, 20])
    user.provider = auth.provider
    user.uid = auth.uid
    user.display_name ||= auth.info.name
    user.save!
    user
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
