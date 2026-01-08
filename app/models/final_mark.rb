class FinalMark < ApplicationRecord
  belongs_to :student, class_name: "Student"
  belongs_to :assignment
  belongs_to :group
  belongs_to :assignment_group_score

  validates :score, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :student, :assignment, :group, :assignment_group_score, presence: true
  validate :student_in_group
  validate :group_belongs_to_assignment_course

  before_save :set_calculated_at, if: :score_changed?

  scope :for_assignment, ->(assignment) { where(assignment: assignment) }
  scope :for_student, ->(student) { where(student: student) }
  scope :for_group, ->(group) { where(group: group) }
  scope :qass, -> { where(assignment_type: 'qass') }
  scope :webavalia, -> { where(assignment_type: 'webavalia') }

  private

  def student_in_group
    return unless student && group

    unless group.students.exists?(student.id)
      errors.add(:student, "must be a member of the specified group")
    end
  end

  def group_belongs_to_assignment_course
    return unless assignment && group

    unless group.course_id == assignment.course_id
      errors.add(:group, "must belong to the same course as the assignment")
    end
  end

  def set_calculated_at
    self.calculated_at ||= Time.current
  end
end

# == Schema Information
#
# Table name: final_marks
#
#  id                        :integer          not null, primary key
#  student_id                :integer          not null
#  assignment_id             :integer          not null
#  group_id                  :integer          not null
#  assignment_group_score_id :integer          not null
#  score                     :decimal(5, 2)    not null
#  calculated_at             :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  idx_fm_on_ags_id                                (assignment_group_score_id)
#  idx_fm_on_assignment_id                         (assignment_id)
#  idx_fm_on_group_id                              (group_id)
#  idx_fm_on_student_and_assignment                (student_id,assignment_id) UNIQUE
#  index_final_marks_on_assignment_group_score_id  (assignment_group_score_id)
#  index_final_marks_on_assignment_id              (assignment_id)
#  index_final_marks_on_group_id                   (group_id)
#  index_final_marks_on_student_id                 (student_id)
#
