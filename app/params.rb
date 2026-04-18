# frozen_string_literal: true

# Triggers:
#   - LongParameterList (> 3 params by default)
#   - BooleanParameter (flag parameter)
#   - ControlParameter (param only used to direct control flow)
#   - UncommunicativeParameterName (single-letter names)
class Params
  def do_stuff(a, b, c, d, e, verbose)
    if verbose
      puts "#{a}, #{b}, #{c}, #{d}, #{e}"
    else
      a + b + c + d + e
    end
  end

  def only_branches_on_arg(enabled)
    return nil unless enabled
    :done
  end
end
