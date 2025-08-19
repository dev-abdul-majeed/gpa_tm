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

