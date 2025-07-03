class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable   

  # Validations
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :gender, presence: true, length: { maximum: 10 }, inclusion: { in: %w[Male Female Other] }
  validates :email, presence: true, length: { maximum: 150 }
  validates :date_of_birth, presence: true
  validates :type, presence: true
end
