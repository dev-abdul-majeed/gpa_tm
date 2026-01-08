class Assignment < ApplicationRecord
  belongs_to :course

  has_many :peer_marks, dependent: :destroy
  has_many :peer_mark_submissions, dependent: :destroy
  has_many :assignment_group_scores, dependent: :destroy
  has_many :final_marks, dependent: :destroy

  validates :title, presence: true, length: { maximum: 50 }
  validates :assignment_type, presence: true, inclusion: { in: %w[qass webavalia] }
  validates :rating_scale, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100
  }
  validates :rating_model, presence: true, inclusion: { in: %w[B C D] }
  validates :self_rating_weight, numericality: {
    greater_than_or_equal_to: 0.0,
    less_than_or_equal_to: 100.0
  }
  validates :start_date_time, presence: true
  validates :end_date_time, presence: true
  validate :end_date_after_start_date

  before_validation :set_default_rating_model, on: :create

  def qass?
    assignment_type == 'qass'
  end

  def webavalia?
    assignment_type == 'webavalia'
  end

  private

  def end_date_after_start_date
    return if end_date_time.blank? || start_date_time.blank?

    if end_date_time <= start_date_time
      errors.add(:end_date_time, "must be after start date time")
    end
  end

  def set_default_rating_model
    self.rating_model ||= 'B'
  end
end

# == Schema Information
#
# Table name: assignments
#
#  id                 :integer          not null, primary key
#  title              :string(50)       not null
#  assignment_type    :string           not null
#  rating_scale       :integer          default("0"), not null
#  rating_model       :string           default("B")
#  calibration        :boolean          default("false")
#  start_date_time    :datetime
#  end_date_time      :datetime
#  self_rating_weight :decimal(5, 2)    default("0.0")
#  course_id          :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  lower_bound        :integer          default("1")
#  upper_bound        :integer          default("7")
#  border_size        :float            default("0.003")
#  polarity_factor    :float            default("1.0")
#  group_spread       :float            default("0.5")
#  group_score        :float            default("0.8"), not null
#
# Indexes
#
#  index_assignments_on_assignment_type  (assignment_type)
#  index_assignments_on_calibration      (calibration)
#  index_assignments_on_course_id        (course_id)
#  index_assignments_on_rating_scale     (rating_scale)
#
