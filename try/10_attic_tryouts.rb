require_relative '../lib/attic'

#
# Tests for the Attic module
#

## A class we define can extend Attic
class ::ExampleClass
  extend Attic
  def kind() :unlikely_value end
end
ExampleClass.methods.member?(:attic)
#=> true

## Trying to include Attic raises an exception
begin
  class ::ExampleClass
    include Attic
  end
rescue => e
  e.class
end
#=> RuntimeError

## Can define attic variables at class level
ExampleClass.attic :size
w = ExampleClass.new
w.respond_to? :size
#=> true

## Accessing attic vars at the instance level fails
begin
  w = ExampleClass.new
  w.attic :size, 2
rescue => e
  e.class
end
#=> NoMethodError

## Can access attic vars the long way though
w = ExampleClass.new
w.attic_variable_set :size, 2
w.attic_variable_get :size
#=> 2

## Won't clobber an existing method with the same name
## NOTE: But also won't tell you it didn't define the method
ExampleClass.attic :kind
a = ExampleClass.new
a.kind
#=> :unlikely_value
