# frozen_string_literal: true

# Triggers:
#   - InstanceVariableAssumption (@log used without initialisation)
#   - ModuleInitialize (module with initialize method)
module Uninit
  def initialize
    @log = []
  end

  def record(event)
    @log << event
    @log.size
  end
end
