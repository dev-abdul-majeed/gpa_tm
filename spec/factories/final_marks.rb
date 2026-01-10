FactoryBot.define do
  factory :final_mark do
    student { association :student }
    assignment
    group
    assignment_group_score
    score { 85.5 }
    calculated_at { nil }
  end
end
