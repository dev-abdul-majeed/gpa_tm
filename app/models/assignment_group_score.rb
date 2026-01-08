class AssignmentGroupScore < ApplicationRecord
  belongs_to :assignment
  belongs_to :group, optional: true
  has_many :final_marks, dependent: :restrict_with_error

  validates :group_score, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :assignment, presence: true
  validate :group_belongs_to_assignment_course, if: :group_id?

  before_save :set_timestamp

  scope :for_assignment, ->(assignment) { where(assignment: assignment) }
  scope :for_group, ->(group) { where(group: group) }
  scope :defaults, -> { where(group_id: nil) }
  scope :group_specific, -> { where.not(group_id: nil) }

  def default?
    group_id.nil?
  end

  def group_specific?
    !default?
  end

  # Find or initialize the appropriate score for an assignment and group
  # Returns group-specific score if exists, otherwise default score
  def self.find_or_initialize_for(assignment, group = nil)
    # Try to find group-specific score first
    if group
      score = find_by(assignment: assignment, group: group)
      return score if score
    end

    # Fall back to default (assignment-level) score
    find_or_initialize_by(assignment: assignment, group: nil)
  end

  private

  def group_belongs_to_assignment_course
    return unless assignment && group

    unless group.course_id == assignment.course_id
      errors.add(:group, "must belong to the same course as the assignment")
    end
  end

  def set_timestamp
    self.set_at ||= Time.current if group_score_changed?
  end
end

# == Schema Information
#
# Table name: assignment_group_scores
#
#  id            :integer          not null, primary key
#  assignment_id :integer          not null
#  group_id      :integer
#  group_score   :decimal(5, 2)    not null
#  set_at        :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  idx_ags_on_assignment_and_group                 (assignment_id,group_id) UNIQUE
#  idx_ags_on_assignment_id                        (assignment_id)
#  index_assignment_group_scores_on_assignment_id  (assignment_id)
#  index_assignment_group_scores_on_group_id       (group_id)
#
