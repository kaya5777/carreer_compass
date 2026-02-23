FactoryBot.define do
  factory :mock_answer do
    interview_question
    ai_session
    user_answer { Faker::Lorem.paragraph(sentence_count: 3) }
    ai_feedback { nil }
    score { nil }
  end
end
