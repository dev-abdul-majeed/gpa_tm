class School < ApplicationRecord
  has_many :teachers, class_name: "Teacher", dependent: :nullify
  has_many :students, class_name: "Student", dependent: :nullify
  has_one :admin, class_name: "Admin", dependent: :nullify

  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :location, presence: true, length: { maximum: 150 }
  validates :domain, presence: true, , length: { maximum: 100 }
end
