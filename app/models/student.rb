class Student < User
  belongs_to :school
  validates :school, presence: true

  has_and_belongs_to_many :courses, class_name: 'Course', join_table: :course_students
end