# frozen_string_literal: true

# Demonstrates: LongParameterList, DuplicateMethodCall, HighComplexity,
# UncommunicativeMethodName, UncommunicativeVariableName.
class Monolith
  def do_everything(a, b, c, d, e, f, g)
    x = a + b + c + d + e + f + g
    y = a + b + c + d + e + f + g
    z = a + b + c + d + e + f + g
    result = x + y + z
    puts result
    puts result
    result
  end

  def m(n)
    n * 2
  end
end
