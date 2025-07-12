class Student < User
  belongs_to :school
  validates :school, presence: true

end