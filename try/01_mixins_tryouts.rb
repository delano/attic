require_relative '../lib/attic'

#
# Tests for the Object mixins that Attic relies on.
#

## Has a valid NoMetaClass exception class
NoMetaClass < RuntimeError
#=> true

## Has a pre-populated array of built-ins without a metaclass
Object::NOMETACLASS
#=> [Symbol, Integer]

## The pre-populated array of built-ins is frozen
Object::NOMETACLASS.frozen?
#=> true

## Has Object#metaclass method
Object.new.respond_to? :metaclass
#=> true

## Object#metaclass is a class
Object.new.metaclass.class
#=> Class

## Object#metaclass is a class
Object.new.metaclass.object_id.class
#=> Integer

## Object#metaclass is a class
a = Object.new
b = Object.new
a.metaclass.object_id == b.metaclass.object_id
#=> false

## Object#metaclass is an Object class
Object.new.metaclass.superclass
#=> Object

## Object#metaclass is equivalent to `class << self; self; end;`
a = Object.new
a.metaclass == (class << a; self; end)
#=> true

## Integer doesn't have a metaclass
Integer.nometaclass?
#=> true

## Symbol doesn't have a metaclass
Symbol.nometaclass?
#=> true

## Object has a metaclass
Object.nometaclass?
#=> false

## Integer has a metaclass
Integer.metaclass?
#=> true

## Symbol has a metaclass
Symbol.metaclass?
#=> true

## Object has a metaclass
Object.metaclass?
#=> true

## Object#metaclass is equivalent to Object#singleton_class
a = Object.new
a.metaclass == a.singleton_class
#=> true
