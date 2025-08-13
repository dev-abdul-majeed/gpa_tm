class Assignment < ApplicationRecord
  belongs_to :course

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