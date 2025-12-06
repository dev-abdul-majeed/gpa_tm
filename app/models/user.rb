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


  def full_name
    "#{first_name} #{last_name}"
  end

  def teacher?
    type == 'Teacher'
  end
  
  def student?
    type == 'Student'
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
