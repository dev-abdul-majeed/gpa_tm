FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    date_of_birth { Faker::Date.between(from: '1990-01-01', to: '2000-12-31') }
    gender { %w[Male Female Other].sample }
    password { "password123" }
    password_confirmation { "password123" }
    type { "User" }
  end
end
