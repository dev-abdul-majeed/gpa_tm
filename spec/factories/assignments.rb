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

# == Schema Information
#
# Table name: assignments
#
#  id                 :integer          not null, primary key
#  title              :string(50)       not null
#  assignment_type    :string           not null
#  rating_scale       :integer          default("0"), not null
#  rating_model       :string           default("B")
#  calibration        :boolean          default("false")
#  start_date_time    :datetime
#  end_date_time      :datetime
#  self_rating_weight :decimal(5, 2)    default("0.0")
#  course_id          :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  lower_bound        :integer          default("1")
#  upper_bound        :integer          default("7")
#  border_size        :float            default("0.003")
#  polarity_factor    :float            default("1.0")
#  group_spread       :float            default("0.5")
#  group_score        :float            default("0.8"), not null
#
# Indexes
#
#  index_assignments_on_assignment_type  (assignment_type)
#  index_assignments_on_calibration      (calibration)
#  index_assignments_on_course_id        (course_id)
#  index_assignments_on_rating_scale     (rating_scale)
#
