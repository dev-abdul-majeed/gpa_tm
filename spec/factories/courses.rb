
FactoryBot.define do
  factory :course do
    name { Faker::Book.title  }
    description { Faker::Books::Dune.quote }
  end
end



# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  teacher_id  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_courses_on_teacher_id           (teacher_id)
#  index_courses_on_teacher_id_and_name  (teacher_id,name) UNIQUE
#
