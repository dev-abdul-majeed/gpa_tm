class GroupMembership < ApplicationRecord
  belongs_to :group
  belongs_to :student, class_name: 'Student', foreign_key: 'student_id'
  
  # Custom validation to ensure one student per group per course
  validate :student_can_only_be_in_one_group_per_course
  
  private
  
  def student_can_only_be_in_one_group_per_course
    return unless student && group
    
    existing_membership = GroupMembership.joins(:group)
                                       .where(student: student, groups: { course: group.course })
                                       .where.not(id: id)
                                       .first
    
    if existing_membership
      errors.add(:student, "can only belong to one group per course")
    end
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
