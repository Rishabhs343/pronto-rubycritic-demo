# frozen_string_literal: true

# Triggers:
#   - NestedIterators (blocks nested 3+ levels deep)
#   - DuplicateMethodCall (row.values called repeatedly)
class Nested
  def count_triples(matrix)
    total = 0
    matrix.each do |row|
      row.each do |col|
        col.each do |cell|
          total += 1 if cell.positive?
        end
      end
    end
    total
  end
end
