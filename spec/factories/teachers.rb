FactoryBot.define do
  factory :teacher do
    school
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name  }
    last_name { Faker::Name.last_name }
    date_of_birth { Faker::Date.between(from: '1999-09-23', to: '2001-09-25') }
    gender { Faker::Gender.binary_type }
    password { "password123" }
    password_confirmation { "password123" }
  end
end

    #  id                     :integer          not null, primary key
    #  email                  :string(150)      default(""), not null
    #  encrypted_password     :string           default(""), not null
    #  reset_password_token   :string
    #  reset_password_sent_at :datetime
    #  remember_created_at    :datetime
    #  sign_in_count          :integer          default("0"), not null
    #  first_name             :string(50)       not null
    #  last_name              :string(50)       not null
    #  gender                 :string(10)       not null
    #  date_of_birth          :date             not null
    #  type                   :string           not null
    #  created_at             :datetime         not null
    #  updated_at             :datetime         not null
    #  school_id              :integer
