# frozen_string_literal: true

# Demonstrates: structural duplication (flay) — pair with validator_a.rb.
class CompanyValidator
  def valid?(company)
    return false if company.name.nil?
    return false if company.name.strip.empty?
    return false if company.name.length > 100
    return false if company.email.nil?
    return false if company.email.strip.empty?

    true
  end
end
