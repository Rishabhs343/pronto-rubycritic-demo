# frozen_string_literal: true

# Represents legacy code that was already on main BEFORE this PR was opened.
# Even though it has obvious smells (LongParameterList, DuplicateMethodCall,
# UncommunicativeVariableName), pronto-rubycritic MUST NOT flag any of these
# lines because the PR diff does not touch them.
class LegacyGarbage
  def horrible_method(a, b, c, d, e, f, g, h)
    y = a + b + c + d + e + f + g + h
    y = a + b + c + d + e + f + g + h
    y = a + b + c + d + e + f + g + h
    y
  end
end
