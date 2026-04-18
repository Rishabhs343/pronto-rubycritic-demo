# frozen_string_literal: true

# Triggers: SelfAssignment — assigning to self inside an instance method
# (Ruby lets you do `self.foo = ...`, but it's almost always wrong).
class SelfAssign
  attr_accessor :name

  def rename(new_name)
    self.name = new_name
  end
end
