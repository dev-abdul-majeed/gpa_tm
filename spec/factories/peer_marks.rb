FactoryBot.define do
  factory :peer_mark do
    assignment
    group
    giver { association :student }
    receiver { association :student }
    score { 75 }
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
