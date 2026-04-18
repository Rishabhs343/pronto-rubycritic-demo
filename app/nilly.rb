# frozen_string_literal: true

# Triggers:
#   - NilCheck (explicit .nil? calls)
#   - MissingSafeMethod (question-mark method without safe counterpart)
class Nilly
  def drop!
    @items = []
  end

  def describe(value)
    if value.nil?
      'missing'
    elsif value.to_s.nil?
      'blank'
    else
      value.to_s
    end
  end
end
