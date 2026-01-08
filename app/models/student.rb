class Student < User
  belongs_to :school
  validates :school, presence: true

  has_and_belongs_to_many :courses, class_name: 'Course', join_table: :course_students

  has_many :group_memberships, foreign_key: 'student_id', dependent: :destroy
  has_many :groups, through: :group_memberships
  has_many :final_marks, foreign_key: 'student_id', dependent: :destroy

  def group_for_course(course)
    groups.joins(:course).where(courses: { id: course.id }).first
  end
  
  # Check if student is in a group for a specific course
  def in_group_for_course?(course)
    group_for_course(course).present?
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(150)      default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  first_name             :string(50)       not null
#  last_name              :string(50)       not null
#  gender                 :string(10)       not null
#  date_of_birth          :date             not null
#  type                   :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  school_id              :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_school_id             (school_id)
#  index_users_on_type_and_email        (type,email)
#
