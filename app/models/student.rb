class Student < User
  belongs_to :school
  validates :school, presence: true

  has_and_belongs_to_many :courses, class_name: 'Course', join_table: :course_students

  has_many :group_memberships, foreign_key: 'student_id', dependent: :destroy
  has_many :groups, through: :group_memberships

  def group_for_course(course)
    groups.joins(:course).where(courses: { id: course.id }).first
  end
  
  # Check if student is in a group for a specific course
  def in_group_for_course?(course)
    group_for_course(course).present?
  end
end
