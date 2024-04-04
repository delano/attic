require_relative "../lib/attic"

Attic.construct Symbol #, :name

## has list of no metaclass classes
NoSingletonError::MEMBERS
#=> [Symbol, Integer]

# ## Symbol metaclass does not raise an exception
# begin
#   :any.attic.class
# rescue NoSingletonError
#   :failed
# end
# #=> :failed

## Accessing Symbol metaclass raises an exception
begin
  :any.attic.class
rescue NoSingletonError
  :failed
end
#=> :failed

## Symbol instances don't cross streams
Symbol.extend Attic
Symbol.attic :name
a, b = :symbol1, :symbol2
a.name = :roger
[a.name, b.name]
#=> [:roger, nil]

## attic? method exists
Symbol.extend Attic
:any.respond_to? :attic?
#=> true

## attic? method is false for a Symbol", false do
:any.attic?
#=> false

## A Symbol's attic vars appear in `all_instance_variables` do
Symbol.extend Attic
Symbol.attic :_name
a, b = :symbol1, :symbol2
a._name = :roger
a.all_instance_variables
#=> [:@___attic_name]

## An Integer's attic vars appear in `all_instance_variables` do
Integer.extend Attic
Integer.attic :_name
a, b = 1, 2
a._name = :roger
a.all_instance_variables
#=> [:@___attic_name]

## A Symbol's attic vars do not appear in `instance_variables` do
Symbol.extend Attic
Symbol.attic :name
a, b = :symbol1, :symbol2
a.name = :roger
a.instance_variables
#=> []

## knows attic variables, [:name] do
Symbol.attic_variables
#=> [:name]
