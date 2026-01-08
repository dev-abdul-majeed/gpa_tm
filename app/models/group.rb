class Group < ApplicationRecord
  belongs_to :course
  has_many :group_memberships, dependent: :destroy
  has_many :students, through: :group_memberships, source: :student
  has_many :assignment_group_scores, dependent: :destroy
  has_many :final_marks, dependent: :destroy
  
  validates :group_name, presence: true
  validates :group_name, uniqueness: { scope: :course_id }
  
  # Add a student to this group (with validation)
  def add_student(student)
    # Check if student is already in another group for this course
    existing_membership = GroupMembership.joins(:group)
                                       .where(student: student, groups: { course: course })
                                       .first
    
    if existing_membership && existing_membership.group != self
      existing_membership.destroy
    end
    
    group_memberships.find_or_create_by(student: student)
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
