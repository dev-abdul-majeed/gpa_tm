class Course < ApplicationRecord
  alias_attribute :course_teacher_id, :teacher_id

belongs_to :teacher, class_name: 'Teacher', foreign_key: 'teacher_id'
  has_and_belongs_to_many :students, class_name: 'Student', join_table: :course_students
  validates :name, presence: true
  validates :description, presence: true
end


