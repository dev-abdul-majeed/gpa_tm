class Teacher < User
  belongs_to :school
  validates :school, presence: true
end