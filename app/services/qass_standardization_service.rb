class QassStandardizationService
  def initialize(assignment_id, group_id, other_params = {})
    @assignment = Assignment.find_by(id: assignment_id)
    @group = Group.find(group_id)

    @submitted_givers = PeerMarkSubmission
      .where(assignment: @assignment, submitted: true)
      .pluck(:giver_id)

    @students = @group.students

    @peer_marks = PeerMark
      .where(assignment: @assignment, group: @group, giver_id: @submitted_givers)
      .to_a

    # Build lookup hash for fast access
    @marks_by_pair = @peer_marks.index_by { |m| [m.giver_id, m.receiver_id] }

    @params = other_params

    if webavalia_to_qass_conversion?
      @marks_by_pair = @marks_by_pair.transform_values do |v|
        v.score = 1 + (((v.score - 1)/99)*6)

        v
      end
    end

    @conversion_group_score = webavalia_to_qass_conversion? ? @params['current_group_score'].to_f / 20.0 : nil

    @required_params_hash = input_params
    @weightj = 0.20
  end

  def converted_evalutation_matrix
    if webavalia_to_qass_conversion?
      @marks_by_pair.transform_values(&:score)
    else
      nil
    end
  end

  def input_params
    if webavalia_to_qass_conversion?
      {
        border_size: 0.003,
        rating_model: 'B',
        polarity_factor: 1.0,
        group_spread: 0.5,
        group_score: @conversion_group_score
      }
    else
      {
        border_size: @assignment.border_size,
        rating_model: @assignment.rating_model,
        polarity_factor: @assignment.polarity_factor,
        group_spread: @assignment.group_spread,
        group_score: @assignment.group_score
      }
    end
  end

  def webavalia_to_qass_conversion?
    @params.present? && @params['conversion'] == 'webavalia-to-qass'
  end

  def qass_standardization
    puts "Peer COUNT ---> #{@peer_marks.count} , student count --> #{@students.count}"
    return nil unless @peer_marks.count == (@students.count ** 2)
    return nil unless (@assignment.qass? || webavalia_to_qass_conversion?)

    lower_bound, upper_bound = *[ @assignment.lower_bound.to_f, @assignment.upper_bound.to_f ]
    if webavalia_to_qass_conversion?
      lower_bound, upper_bound = *[ 1, 7 ]
    end

    pair_marks_with_values =  @marks_by_pair.transform_values(&:score)

    pair_marks_with_values.transform_values { |score| ((score - lower_bound)/(upper_bound - lower_bound))}
  end

  def bordered_peer_ratings
    values_hash = qass_standardization

    return nil unless values_hash.present?

    border_size = @required_params_hash[:border_size]

    values_hash.map do |pair, score|
      giver, receiver = *pair
      border_rating = lambda {|score_value| (1 - ((1-border_size)*(1-score))) }

      if @assignment.rating_model == 'C'
        if giver == receiver
          [ pair, 1.0 ]
        else
          [ pair, (1 - ((1-border_size)*(1-score))) ]
        end
      elsif @assignment.rating_model == 'B' || webavalia_to_qass_conversion?
        [ pair, ((((1-border_size)*score)) + (border_size* (1-score))) ]
      elsif @assignment.rating_model == 'D'
        if giver == receiver
          [pair, 0.0]
        else
          [pair, ((1-border_size)*score)]
        end
      end
    end.to_h
  end

  def rescaled_peer_ratings
    bpratings = bordered_peer_ratings

    return nil if bpratings.blank?

    rating_model = @assignment.rating_model

    bpratings.transform_values do |v|
      if rating_model == 'C'
        (v / (2- v))
      elsif rating_model == 'B' || webavalia_to_qass_conversion?
        (v / (1 - v))
      elsif rating_model == 'D'
        ((1 + v) / (1 - v))
      end
    end
  end

  def calibrated_peer_ratings
    rs_peer_ratings = rescaled_peer_ratings

    rating_model = @required_params_hash[:rating_model]

    return rs_peer_ratings if %W[C D].include?(rating_model)

    return nil unless rs_peer_ratings.present?

    bp_ratings = bordered_peer_ratings
    rs_peer_ratings_copy = rs_peer_ratings
    rs_peer_ratings.map do |pair, value|
      giver, receiver = *pair

      [ pair, ((value)/(bp_ratings[[receiver, receiver]]/(1 - bp_ratings[[receiver, receiver]]))) ]
    end.to_h
  end

  def weighted_peer_ratings
    c_peer_ratings = calibrated_peer_ratings

    return nil if c_peer_ratings.blank?

    # return nil
    rating_model = @assignment.rating_model

    c_peer_ratings_copy = c_peer_ratings
    # weightj = 0.20
    c_peer_ratings.map do |pair, value|
      giver, receiver = *pair

      if rating_model == "B" || webavalia_to_qass_conversion?
        [ pair, (value ** @weightj) ]
      elsif rating_model == "C"
        [ pair, (value ** @weightj) ]
      elsif rating_model == "D"
        [ pair, (value ** @weightj) ]
      end
    end.to_h
  end

  def student_ratings
    w_peer_ratings = weighted_peer_ratings

    return nil if w_peer_ratings.blank?

    student_ids = w_peer_ratings.keys.flatten(1).uniq

    # result = {}
    student_ids.map do |receiver|

      [receiver, student_ids.inject(1) {|acc, giver| acc * w_peer_ratings[[giver, receiver]] }]
      # student_ids.each do |giver|
      #   mul = w_peer_ratings[giver, receiver] * mul
      # end

      # result[receiver] = mul

    end.to_h
  end

  def mean_student_rating
    s_ratings = student_ratings

    return nil if s_ratings.blank?

    # weightj = 0.20

    s_ratings.transform_values{ |v| v** @weightj }.values.inject(1){|acc, v| acc * v }
  end

  def student_contributions
    m_student_rating = mean_student_rating

    return nil if m_student_rating.blank?

    polarity_factor = @required_params_hash[:polarity_factor]
    rating_model = @required_params_hash[:rating_model]

    s_ratings = student_ratings
    m_s_rating = mean_student_rating

    if rating_model == 'B' ||  webavalia_to_qass_conversion?
      s_ratings.transform_values{ |v| (v ** polarity_factor)/(mean_student_rating ** polarity_factor) }
    elsif rating_model == 'C'
      s_ratings.transform_values{ |v| ((v /mean_student_rating)**(1/polarity_factor)) }

    elsif rating_model == 'D'
      s_ratings.transform_values{ |v| ((v /mean_student_rating)**(polarity_factor)) }
    end
  end

  def student_contributions_ci
    s_contributions = student_contributions

    return nil if s_contributions.blank?

    rating_model = @required_params_hash[:rating_model]

    if rating_model == 'B' || webavalia_to_qass_conversion?
      s_contributions.transform_values { |v| ((v - 1)/(v + 1)) }
    elsif rating_model == 'C'
      s_contributions.transform_values { |v| (((3 * v) - 1)/(v + 1))}
    elsif rating_model == 'D'
      s_contributions.transform_values { |v| ((v - 3)/(v + 1))}
    end
  end

  def mean_student_contribution
    s_contributions = student_contributions

    return nil if s_contributions.blank?

    s_contributions.transform_values{|v| v ** @weightj }
                   .values
                   .inject(1) {|acc, v| acc * v }
  end


  def c_bar
    m_s_contribution = mean_student_contribution

    return nil if m_s_contribution.blank?

    rating_model =  @required_params_hash[:rating_model]

    if rating_model == 'B' || webavalia_to_qass_conversion?
     (m_s_contribution - 1)/(m_s_contribution + 1)
    elsif rating_model == 'C'
      (3 * m_s_contribution)/4
    elsif rating_model == 'D'
     (m_s_contribution - 3)/(m_s_contribution + 1)
    end
  end

  def mean_student_score(group_score = nil)
    t = webavalia_to_qass_conversion? ? @required_params_hash[:group_score] : (group_score || @assignment.group_score)
    z = @required_params_hash[:group_spread]

    c_bar_v = c_bar

    return nil unless c_bar_v

    (t ** (z ** c_bar_v))
  end

  def student_scores(group_score = nil)
    ci = student_contributions_ci

    return nil if ci.blank?

    t = webavalia_to_qass_conversion? ? @required_params_hash[:group_score] : (group_score || @assignment.group_score)
    z = @required_params_hash[:group_spread]

    ci.transform_values {|v| (t ** (z ** v))}
  end
end
