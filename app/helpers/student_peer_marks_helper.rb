module StudentPeerMarksHelper
  def disbale_peer_marks?(submission, peer_mark)
    return true if submission.submitted?

    assignment = peer_mark.assignment
    is_qass_type = assignment.assignment_type == 'qass'

    if is_qass_type && %w[B D].include?(assignment.rating_model) && peer_mark.receiver_id == current_user.id
      true
    else
      false
    end
  end

  def default_or_saved_score(submission, peer_mark)
    return peer_mark&.score if submission.submitted?

    assignment = peer_mark.assignment
    is_qass_type = assignment.assignment_type == 'qass'

    if is_qass_type && %w[B D].include?(assignment.rating_model) && peer_mark.receiver_id == current_user.id
      if assignment.rating_model == 'B'
        assignment.upper_bound.to_f
      elsif assignment.rating_model == 'D'
        assignment.lower_bound.to_f
      end
    else
      peer_mark&.score || 0
    end
  end

  def should_distribute_marks_or_not_prompt(assignment)
    if assignment.assignment_type == 'qass'
      'Give marks betweeen 1 and 7 excluding yourself.'
    else
      'Distribute exactly 100 points across your group members (including yourself).'
    end
  end

  def peer_mark_max(assignment)
    if assignment.assignment_type == 'qass'
      assignment.upper_bound
    else
      100
    end
  end

  def peer_mark_min(assignment)
    if assignment.assignment_type == 'qass'
      assignment.lower_bound
    else
      0
    end
  end
end
