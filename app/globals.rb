# frozen_string_literal: true

# Triggers:
#   - ClassVariable (uses @@)
#   - TooManyConstants (> 5 constants)
#   - TooManyInstanceVariables (> 4 instance vars)
#   - TooManyMethods (> 15 methods)
class Globals
  FOO = 1
  BAR = 2
  BAZ = 3
  QUX = 4
  QUUX = 5
  CORGE = 6
  GRAULT = 7

  @@class_var = 0

  def initialize
    @a = 1
    @b = 2
    @c = 3
    @d = 4
    @e = 5
    @f = 6
  end

  def m1; @a; end
  def m2; @b; end
  def m3; @c; end
  def m4; @d; end
  def m5; @e; end
  def m6; @f; end
  def m7; @a + @b; end
  def m8; @a + @c; end
  def m9; @a + @d; end
  def m10; @a + @e; end
  def m11; @a + @f; end
  def m12; @b + @c; end
  def m13; @b + @d; end
  def m14; @b + @e; end
  def m15; @b + @f; end
  def m16; @c + @d; end
  def m17; @@class_var; end
end
