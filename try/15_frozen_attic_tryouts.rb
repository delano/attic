require_relative '../lib/attic'

# Tests for the frozen objects

# A class we define can extend Attic
class ::ExampleClass
  extend Attic
end

ExampleClass.methods.member?(:attic)
#=> true

# Classes that extend Attic don't spawn frozen instances
a = ExampleClass.new
a.frozen?
#=> false

# Classes that extend Attic and have attic variables
# also don't spawn frozen instances
ExampleClass.attic :size
a = ExampleClass.new
a.frozen?
#=> false

# Instances can still freeze normally
a = ExampleClass.new
a.freeze
a.frozen?
#=> true

# Instances can still freeze normally even if they
# have attic with values
ExampleClass.attic :size
a = ExampleClass.new
a.size = 2
a.freeze
[a.frozen?, a.size]
#=> [true, 2]

# Frozen instances can't have their attic vars changed either
a = ExampleClass.new
a.size = 2
a.freeze
begin
  a.size = 3
rescue => e
  e.class
end
#=> FrozenError

# Regardless of the behaviour of the instance itself, once
# it's frozen, its singleton class is frozen too!
a = ExampleClass.new
a.freeze
a.singleton_class.frozen?
#=> true

# Frozen instances can't have their attic vars changed either
a = ExampleClass.new
a.size = 2
a.freeze
begin
  a.size = 3
rescue => e
  e.class
end
#=> FrozenError
