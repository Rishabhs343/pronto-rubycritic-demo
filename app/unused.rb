# frozen_string_literal: true

# Triggers:
#   - UnusedParameters (context param never used)
#   - UnusedPrivateMethod (never_called_helper)
class Unused
  def process(record, context)
    record.to_s.upcase
  end

  private

  def never_called_helper
    'lonely'
  end
end
