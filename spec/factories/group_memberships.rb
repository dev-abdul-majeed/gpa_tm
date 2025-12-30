FactoryBot.define do
  factory :group_membership do
    group { association :group }
    student { association :student }
  end
end

# == Schema Information
#
# Table name: group_memberships
#
#  id         :integer          not null, primary key
#  group_id   :integer          not null
#  student_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_group_memberships_on_group_id                 (group_id)
#  index_group_memberships_on_student_id               (student_id)
#  index_group_memberships_on_student_id_and_group_id  (student_id,group_id) UNIQUE
#
