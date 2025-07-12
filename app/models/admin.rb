class Admin < User
  belongs_to :school
  validates :school, presence: true
end