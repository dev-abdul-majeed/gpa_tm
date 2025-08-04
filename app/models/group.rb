class Group < ApplicationRecord
  belongs_to :course
  has_many :group_memberships, dependent: :destroy
  has_many :students, through: :group_memberships, source: :student
  
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
