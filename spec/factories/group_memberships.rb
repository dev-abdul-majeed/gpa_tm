FactoryBot.define do
  factory :group_membership do
    group { association :group }
    student { association :student }
  end
end
