module AssignmentHelper
  MARK_BADGE_THEMES = {
    emerald: "bg-emerald-50 border-emerald-200 text-emerald-800",
    blue: "bg-blue-50 border-blue-200 text-blue-800",
    purple: "bg-purple-50 border-purple-200 text-purple-800",
    orange: "bg-orange-50 border-orange-200 text-orange-800",
    green: "bg-green-50 border-green-200 text-green-800",
    cyan: "bg-cyan-50 border-cyan-200 text-cyan-800"
  }.freeze

  def format_mark_for_display(value, precision: nil)
    return nil if value.nil?

    number = value.is_a?(Numeric) ? value : Float(value)
    if precision
      format("%.#{precision}f", number)
    elsif number == number.to_i
      number.to_i.to_s
    else
      formatted = format("%.4f", number)
      formatted.sub(/\.?0+\z/, "")
    end
  rescue ArgumentError, TypeError
    value.to_s
  end

  def mark_badge_text_size(text)
    length = text.to_s.length
    return "text-sm" if length <= 3
    return "text-xs" if length <= 6

    "text-[11px]"
  end

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
