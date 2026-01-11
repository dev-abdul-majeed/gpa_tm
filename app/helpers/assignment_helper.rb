module AssignmentHelper
  def conversion_params(conversion_from)
    if conversion_from == 'webavalia-to-qass'
      {
        conversion: 'webavalia-to-qass',
        current_group_score: @current_group_score
      }.with_indifferent_access
    else
      {}
    end
  end

  def normalized_student_scores(student_scores)
    student_scores.transform_values { |v| (v * 100).round(1) }
  end
end
