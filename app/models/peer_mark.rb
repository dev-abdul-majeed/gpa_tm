# app/models/peer_mark.rb
class PeerMark < ApplicationRecord
    belongs_to :assignment
    belongs_to :group
    belongs_to :giver, class_name: "Student"
    belongs_to :receiver, class_name: "Student"

    validates :score, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
    validates :assignment, :group, :giver, :receiver, presence: true
    validates :receiver_id, uniqueness: { scope: [:assignment_id, :giver_id] }

    validate :group_matches_assignment_course
    validate :giver_and_receiver_in_same_group
    validate :giver_belongs_to_group
    validate :receiver_belongs_to_group
    validate :locked_after_submission

    # before_destroy :prevent_destroy_if_submitted

    scope :for_assignment, ->(assignment) { where(assignment: assignment) }
    scope :for_giver, ->(giver) { where(giver: giver) }

    private

    def group_matches_assignment_course
        return unless assignment && group
        if group.course_id != assignment.course_id
            errors.add(:group, "must belong to the same course as the assignment")
        end
    end

    def giver_and_receiver_in_same_group
        return unless giver && receiver && group

        unless group.students.exists?(giver.id) && group.students.exists?(receiver.id)
            errors.add(:base, "Giver and receiver must both be members of the group")
        end
    end

    def giver_belongs_to_group
        return unless giver && group
        unless group.students.exists?(giver.id)
            errors.add(:giver, "must belong to the group")
        end
    end

    def receiver_belongs_to_group
        return unless receiver && group
        unless group.students.exists?(receiver.id)
            errors.add(:receiver, "must belong to the group")
        end
    end

    def locked_after_submission
        submission = PeerMarkSubmission.find_by(assignment: assignment, giver: giver)
        return unless submission&.submitted?

        if will_save_change_to_score? || will_save_change_to_group_id? || will_save_change_to_receiver_id?
            errors.add(:base, "Peer marks are locked after submission")
        end
    end

    def prevent_destroy_if_submitted
        submission = PeerMarkSubmission.find_by(assignment: assignment, giver: giver)
        if submission&.submitted?
            errors.add(:base, "Peer marks are locked after submission")
            throw(:abort)
        end
    end
end

# == Schema Information
#
# Table name: peer_marks
#
#  id            :integer          not null, primary key
#  assignment_id :integer          not null
#  group_id      :integer          not null
#  giver_id      :integer          not null
#  receiver_id   :integer          not null
#  score         :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_peer_marks_on_assignment_giver_receiver  (assignment_id,giver_id,receiver_id) UNIQUE
#  index_peer_marks_on_assignment_id              (assignment_id)
#  index_peer_marks_on_giver_id                   (giver_id)
#  index_peer_marks_on_group_id                   (group_id)
#  index_peer_marks_on_receiver_id                (receiver_id)
#
