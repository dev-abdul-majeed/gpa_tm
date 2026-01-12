class WebavaliaService
  def initialize(assignment_id, group_id, converted = false)
    @assignment = Assignment.find_by(id: assignment_id)
    @group = Group.find(group_id)

    @submitted_givers = PeerMarkSubmission
      .where(assignment: @assignment, submitted: true)
      .pluck(:giver_id)

    @students = @group.students

    @converted = converted

    @peer_marks = PeerMark
      .where(assignment: @assignment, group: @group, giver_id: @submitted_givers)
      .to_a

    # Build lookup hash for fast access
    @marks_by_pair = @peer_marks.index_by { |m| [m.giver_id, m.receiver_id] }

    @self_rating_weight = @assignment.self_rating_weight / 100.0
    @student_count = @students.count

    if @converted
      @self_rating_weight = 0.15
    end
  end

  # Calculate weighted peer marks (self-rating vs peer-rating)
  # Returns a hash: { [giver_id, receiver_id] => weighted_score }
  def weighted_peer_marks
    return {} unless @assignment.webavalia? || @converted

    marks_source = @converted ? normalize_peer_marks : @marks_by_pair

    result = {}
    @students.each do |giver|
      @students.each do |receiver|
        if @converted
          score = marks_source[[giver.id, receiver.id]]
          next unless score.present?
        else
          mark = marks_source[[giver.id, receiver.id]]
          next unless mark.present?
          score = mark.score
        end

        if giver == receiver
          result[[giver.id, receiver.id]] = score * @self_rating_weight
        else
          peer_weight = @student_count > 1 ? ((1 - @self_rating_weight) / (@student_count - 1)) : 0
          result[[giver.id, receiver.id]] = score * peer_weight
        end
      end
    end
    result
  end

  # Calculate row sums for each receiver (sum of weighted marks received)
  # Returns a hash: { receiver_id => row_sum }
  def row_sums
    weighted_marks = weighted_peer_marks
    return {} if weighted_marks.empty?

    result = {}
    @students.each do |receiver|
      sum = 0.0
      @students.each do |giver|
        weighted_score = weighted_marks[[giver.id, receiver.id]]
        sum += weighted_score if weighted_score
      end
      result[receiver.id] = sum
    end
    result
  end

  # Find the maximum row sum
  def max_row_sum
    sums = row_sums
    return 0 if sums.empty?

    sums.values.max || 0
  end

  # Calculate DivideMax for each receiver (row_sum / max_row_sum)
  # Returns a hash: { receiver_id => divide_max }
  def divide_max_values
    sums = row_sums
    max_sum = max_row_sum
    return {} if sums.empty? || max_sum == 0

    sums.transform_values { |sum| sum / max_sum }
  end

  # Calculate Grade for each receiver (DivideMax * group_score)
  # Returns a hash: { receiver_id => grade }
  def grades(group_score = 18)
    divide_max = divide_max_values
    return {} if divide_max.empty?

    divide_max.transform_values { |divide_max_value| divide_max_value * group_score }
  end

  # Calculate Final Grade for each receiver (rounded Grade)
  # Returns a hash: { receiver_id => final_grade }
  def final_grades(group_score = 18)
    grade_values = grades(group_score)
    return {} if grade_values.empty?

    grade_values.transform_values(&:round)
  end

  # Get all calculation results with student IDs
  # Returns a hash with all calculations keyed by student_id
  def student_calculations(group_score = 18)
    sums = row_sums
    max_sum = max_row_sum
    divide_max = divide_max_values
    grade_values = grades(group_score)
    final_grade_values = final_grades(group_score)

    result = {}
    @students.each do |student|
      result[student.id] = {
        student_id: student.id,
        
        row_sum: sums[student.id] || 0,
        max_row_sum: max_sum,
        divide_max: divide_max[student.id] || 0,
        grade: grade_values[student.id] || 0,
        final_grade: final_grade_values[student.id] || 0
      }
    end
    result
  end

  # Get weighted marks for display in table
  # Returns a hash: { [giver_id, receiver_id] => { score: value, mark_id: id } }
  def weighted_marks_with_ids
    weighted_marks = weighted_peer_marks
    result = {}

    @students.each do |giver|
      @students.each do |receiver|
        mark = @marks_by_pair[[giver.id, receiver.id]]
        weighted_score = weighted_marks[[giver.id, receiver.id]]

        if mark.present? && weighted_score
          result[[giver.id, receiver.id]] = {
            score: weighted_score,
            mark_id: mark.id,
            is_self_rating: giver == receiver
          }
        end
      end
    end
    
    result
  end

  def normalize_peer_marks()
    # Group marks by giver
    lower_bound = @assignment.lower_bound
    upper_bound = @assignment.upper_bound
    marks_by_giver = @peer_marks.group_by(&:giver_id)
    
    normalized_marks = {}
    
    marks_by_giver.each do |giver_id, marks|
      # Calculate total points given by this giver on original scale
      total_original = marks.sum(&:score)
      
      # Convert each score to percentage of total, then to base-100 scale
      base_scores = marks.map do |mark|
        percentage = mark.score / total_original.to_f
        base_score = (percentage * 100).round
        { mark: mark, base_score: base_score }
      end
      
      # Round to nearest multiple of 5
      rounded_scores = base_scores.map do |item|
        rounded = (item[:base_score] / 5.0).round * 5
        { mark: item[:mark], score: rounded }
      end
      
      # Adjust to ensure sum equals exactly 100
      current_sum = rounded_scores.sum { |item| item[:score] }
      difference = 100 - current_sum
      
      if difference != 0
        # Sort by how much rounding affected each score (rounding error)
        errors = rounded_scores.map.with_index do |item, idx|
          original_base = base_scores[idx][:base_score]
          error = original_base - item[:score]
          { index: idx, error: error.abs, direction: error <=> 0 }
        end
        
        # Adjust scores with largest rounding errors
        errors.sort_by! { |e| [-e[:error], e[:index]] }
        
        adjustment_step = difference > 0 ? 5 : -5
        adjustments_needed = difference.abs / 5
        
        adjustments_needed.times do |i|
          idx = errors[i][:index]
          rounded_scores[idx][:score] += adjustment_step
          # Ensure we don't go below 0
          rounded_scores[idx][:score] = [0, rounded_scores[idx][:score]].max
        end
      end
      
      # Store normalized scores
      rounded_scores.each do |item|
        normalized_marks[[item[:mark].giver_id, item[:mark].receiver_id]] = item[:score]
      end
    end
    
    normalized_marks
  end
  
    
end

