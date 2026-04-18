# frozen_string_literal: true

# Triggers: SingletonMethodCall — calling a class-level method on another
# class is often a sign of hidden coupling.
class Reporter
  def call
    Logger.new($stdout).info('reporting')
    Kernel.puts('done')
  end
end
