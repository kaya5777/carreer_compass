FactoryBot.define do
  factory :ai_message do
    ai_session
    role { :user }
    content { Faker::Lorem.paragraph }
  end
end
