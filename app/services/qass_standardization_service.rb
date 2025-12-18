class QassStandardizationService
  def initialize(assignment_id, group_id)
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
  end

  def qass_standardization
    puts "Peer COUNT ---> #{@peer_marks.count} , student count --> #{@students.count}"
    return nil unless @peer_marks.count == (@students.count ** 2)
    return nil unless @assignment.qass?

    lower_bound = @assignment.lower_bound.to_f
    upper_bound = @assignment.upper_bound.to_f

    pair_marks_with_values =  @marks_by_pair.transform_values(&:score)

    pair_marks_with_values.transform_values { |score| ((score - lower_bound)/(upper_bound - lower_bound))}
  end

  def bordered_peer_ratings
    values_hash = qass_standardization

    return nil unless values_hash.present?

    border_size = @assignment.border_size

    values_hash.map do |pair, score|
      giver, receiver = *pair
      border_rating = lambda {|score_value| (1 - ((1-border_size)*(1-score))) }

      if @assignment.rating_model == 'C'
        if giver == receiver
          [ pair, 1.0 ]
        else
          [ pair, (1 - ((1-border_size)*(1-score))) ]
        end
      elsif @assignment.rating_model == 'B'
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
      elsif rating_model == 'B'
        (v / (1 - v))
      elsif rating_model == 'D'
        ((1 + v) / (1 - v))
      end
    end
  end

  def calibrated_peer_ratings
    rs_peer_ratings = rescaled_peer_ratings

    rating_model = @assignment.rating_model

    return rs_peer_ratings if %W[C D].include?(rating_model)

    rs_peer_ratings unless rs_peer_ratings.present?

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
    weightj = 0.20
    c_peer_ratings.map do |pair, value|
      giver, receiver = *pair

      if rating_model == "B"
        [ pair, (value ** weightj) ]
      elsif rating_model == "C"
        [ pair, (value ** weightj) ]
      elsif rating_model == "D"
        [ pair, (value ** weightj) ]
      end
    end.to_h
  end
end
