FactoryBot.define do
  factory :assignment_group_score do
    assignment
    group { nil }
    group_score { 0.8 }
    set_at { nil }
  end
end
