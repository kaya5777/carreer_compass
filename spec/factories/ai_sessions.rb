FactoryBot.define do
  factory :ai_session do
    user
    title { "AIセッション" }
    session_type { :strengths_builder }
    status { :active }
    system_prompt { "You are a helpful assistant." }
  end
end
