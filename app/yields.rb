# frozen_string_literal: true

# Triggers: LongYieldList — yielding more than 3 values at once.
class Yielder
  def each_record(&block)
    records.each do |row|
      yield row[0], row[1], row[2], row[3], row[4], row[5]
    end
  end

  private

  def records
    [[1, 2, 3, 4, 5, 6], [7, 8, 9, 10, 11, 12]]
  end
end
