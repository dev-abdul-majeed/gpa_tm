class PeerMarkSubmission < ApplicationRecord
    belongs_to :assignment
    belongs_to :giver, class_name: "Student"

    validates :assignment, :giver, presence: true
    validates :submitted, inclusion: { in: [true, false] }

    # Ensure totals sum to 100 upon submit
    validate :total_score_must_equal_100, if: :submitted?
    validate :cannot_unsubmit, if: -> { will_save_change_to_submitted? }

    before_update :set_submitted_at_timestamp, if: -> { will_save_change_to_submitted? && submitted? }

    def submitted?
        submitted
    end

    def lock!
        update!(submitted: true)
    end

    private

    def total_score_must_equal_100
      # should not check equal to 100 condition for qass
      return if assignment.assignment_type == 'qass'

      total = PeerMark.where(assignment: assignment, giver: giver).sum(:score)
      errors.add(:base, "Total score must equal 100") unless total == 100
    end

    def set_submitted_at_timestamp
        self.submitted_at ||= Time.current
    end

    def cannot_unsubmit
        if submitted_changed?(from: true, to: false)
            errors.add(:submitted, "cannot be reverted once submitted")
        end
    end
end

# == Schema Information
#
# Table name: peer_mark_submissions
#
#  id            :integer          not null, primary key
#  assignment_id :integer          not null
#  giver_id      :integer          not null
#  submitted     :boolean          default("false"), not null
#  submitted_at  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_peer_mark_submissions_on_assignment_and_giver  (assignment_id,giver_id) UNIQUE
#  index_peer_mark_submissions_on_assignment_id         (assignment_id)
#  index_peer_mark_submissions_on_giver_id              (giver_id)
#
