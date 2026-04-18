# frozen_string_literal: true

# Triggers: Attribute — exposing a raw attr_accessor breaks encapsulation.
class Profile
  attr_accessor :email, :phone, :ssn
end
