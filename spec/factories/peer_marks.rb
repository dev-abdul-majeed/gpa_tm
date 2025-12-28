FactoryBot.define do
  factory :peer_mark do
    assignment
    group
    giver { association :student }
    receiver { association :student }
    score { 75 }
  end
end
