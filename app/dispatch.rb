# frozen_string_literal: true

# Triggers: ManualDispatch — calling `respond_to?(:m) && obj.m` instead of
# using duck-typing or an interface check.
class Dispatch
  def maybe_call(target)
    if target.respond_to?(:process)
      target.process
    else
      :skipped
    end
  end
end
