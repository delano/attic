require_relative '../lib/attic'

#
# Tests for the Object mixins that Attic relies on.
#

## Has a valid NoMetaClass exception class
NoMetaClass < RuntimeError
#=> true

## Has a pre-populated array of built-ins without a metaclass
begin
    Object::NOMETACLASS
rescue NameError => e
    e.class
end
#=> NameError

## Has Object#metaclass method
Object.new.respond_to? :metaclass
#=> false

## Has Object#singleton_class method
Object.new.respond_to? :singleton_class
#=> true

## Object#singleton_class is a class
Object.new.singleton_class.class
#=> Class

## Object#singleton_class is a class
Object.new.singleton_class.object_id.class
#=> Integer

## Object#singleton_class is a class
a = Object.new
b = Object.new
a.singleton_class.object_id == b.singleton_class.object_id
#=> false

## Object#singleton_class is an Object class
Object.new.singleton_class.superclass
#=> Object

## Object#singleton_class is equivalent to `class << self; self; end;`
a = Object.new
a.singleton_class == (class << a; self; end)
#=> true

## Integer doesn't have a singleton_class
Integer.singleton_class?
#=> false

## Symbol doesn't have a singleton_class
Symbol.singleton_class?
#=> false

## Object has a singleton_class
Object.singleton_class?
#=> false

## Object#singleton_class is equivalent to Object#singleton_class
a = Object.new
a.singleton_class == a.singleton_class
#=> true
