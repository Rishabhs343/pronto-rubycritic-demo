# frozen_string_literal: true

# Triggers:
#   - UncommunicativeModuleName (single-letter module)
#   - UncommunicativeMethodName (single-letter method)
#   - UncommunicativeVariableName (single-letter local + instance var)
module X
  class Y
    def m
      @n = 1
      q = @n * 2
      z = q + 1
      z
    end
  end
end
