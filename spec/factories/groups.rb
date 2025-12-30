
FactoryBot.define do
  factory :group do
    group_name { Faker::Book.title }
  end
end



# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  group_name :string           not null
#  course_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_groups_on_course_id                 (course_id)
#  index_groups_on_course_id_and_group_name  (course_id,group_name) UNIQUE
#
