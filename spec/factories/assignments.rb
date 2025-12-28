FactoryBot.define do
  factory :assignment do
    course
    title { 'Peer Evaluation 1' }
    assignment_type { 'qass' }
    rating_scale { 100 }
    rating_model { 'B' }
    self_rating_weight { 10.0 }
    start_date_time { 1.day.ago }
    end_date_time { 1.day.from_now }
  end
end
