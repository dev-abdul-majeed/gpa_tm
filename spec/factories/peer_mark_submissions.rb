FactoryBot.define do
  factory :peer_mark_submission do
    assignment
    giver { association :student }
    submitted { false }
    submitted_at { nil }
  end
end
