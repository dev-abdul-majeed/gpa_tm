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
end
