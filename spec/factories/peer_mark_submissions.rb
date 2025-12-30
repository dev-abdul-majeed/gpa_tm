FactoryBot.define do
  factory :peer_mark_submission do
    assignment
    giver { association :student }
    submitted { false }
    submitted_at { nil }
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
