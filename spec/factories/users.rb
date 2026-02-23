FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password123" }
    password_confirmation { "password123" }
    display_name { Faker::Name.name }
    career_stage { :considering }
  end
end
