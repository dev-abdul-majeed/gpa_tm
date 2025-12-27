FactoryBot.define do
  factory :school do
    name { Faker::Name.first_name  }
    location { Faker::University.name }
    domain { Faker::Lorem.paragraph(sentence_count: 3) }
  end
end

# == Schema Information
#
# Table name: schools
#
#  id         :integer          not null, primary key
#  name       :string
#  location   :string
#  domain     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
