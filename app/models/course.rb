class Course < ApplicationRecord
  alias_attribute :course_teacher_id, :teacher_id

  belongs_to :teacher, class_name: 'Teacher', foreign_key: 'teacher_id'
  
  has_many :groups, dependent: :destroy
  has_many :group_memberships, through: :groups, dependent: :destroy
  has_many :assignments, dependent: :destroy
  
  has_and_belongs_to_many :students, class_name: 'Student', join_table: :course_students

  validates :name, presence: true
  validates :description, presence: true

  # Get all students in groups for this course
  def students_in_groups
    Student.joins(:group_memberships).where(group_memberships: { group: groups })
  end
  
  # Get students not in any group for this course
  def students_without_groups
    course_student_ids = students.pluck(:id)
    grouped_student_ids = students_in_groups.pluck(:id)
    Student.where(id: course_student_ids - grouped_student_ids)
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
