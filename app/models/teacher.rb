class Teacher < User
  belongs_to :school
  validates :school, presence: true
  
  has_many :courses, foreign_key: 'course_teacher_id', dependent: :destroy
end