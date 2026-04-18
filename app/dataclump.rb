# frozen_string_literal: true

# Triggers:
#   - DataClump — `start_date, end_date` repeatedly travelling together
#   - RepeatedConditional — same `if start_date > end_date` test in 3 methods
class DateRangeService
  def overlap(start_date, end_date, other_start, other_end)
    return false if start_date > end_date
    !(end_date < other_start || start_date > other_end)
  end

  def duration(start_date, end_date)
    return 0 if start_date > end_date
    (end_date - start_date).to_i
  end

  def humanize(start_date, end_date)
    return 'invalid' if start_date > end_date
    "#{start_date} to #{end_date}"
  end

  def touches_today?(start_date, end_date)
    return false if start_date > end_date
    today = Date.today
    start_date <= today && today <= end_date
  end
end
