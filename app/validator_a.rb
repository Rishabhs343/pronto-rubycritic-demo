# frozen_string_literal: true

# Demonstrates: structural duplication (flay) — pair with validator_b.rb.
class UserValidator
  def valid?(user)
    return false if user.name.nil?
    return false if user.name.strip.empty?
    return false if user.name.length > 100
    return false if user.email.nil?
    return false if user.email.strip.empty?

    true
  end
end
