
# Attic: A special place to store instance variables.

require_relative "attic/class_methods"
require_relative "attic/errors"
require_relative "attic/instance_methods"

# = Attic
#
# == Usage:
#
#  require 'attic'
#  class MyClass
#    include Attic
#    attic :name, :age
#  end
#
#  obj = MyClass.new
#  obj.attic.nickname = 'My Classic Automobile'
#  obj.attic.secret_age  = 27
#
#  obj.nickname      #=> 'My Classic Automobile'
#  obj.secret_age    #=> 27
#  obj.to_h          #=> {}
#
#    OR
#
#  require 'attic'
#  Attic.construct MyClass, :nickname, :secret_age
#
#
# == Description:
#
# Attic is a module that allows you to store instance variables
# in a dedicated singleton class. This is useful for storing
# instance variables that you don't want to be available to
# the public interface of your class. e.g. you want to store
# a value for the running instance but want to prevent it
# from being serialized.
#
# == Why?
#
# == Important Notes:
#
# Some objects just straight up are not capable of contructing
# an attic. `Symbols`, `Integers`, and `Floats` specifically do not
# have a dedicated singleton classes. These are what ruby
# internals refer to as "immediate values". They're special
# in that they are not objects in the traditional sense.
# They're just values (they're not even instances of a
# class 😮‍💨).
#
# When you call attic on an immediate value you get an error.
#
# :sym.attic       #=> raises NoSingleton error
# 1.attic          #=> Ditto
# 1.0.1.attic      #=> Ditto again
#
#
# The other objects that do not have singleton classes are
# `true`, `false`, and `nil`. Calling attic on these don't
# raise an error but they simply return their class. This
# is because they are all instances of their same singleton
# class.
#
# true.attic       #=> TrueClass
# false.attic      #=> FalseClass
# nil.attic        #=> NilClass
#
# Note: this means that every instance of nil
# returns the exact same singleton class. This is different
# from the behaviour of all other objects.
#
# nil.attic.object_id   #=> 800
# nil.attic.object_id   #=> 800
#
#
# NilClass, TrueClass, and FalseClass on the otherhand each
# have their own singleton class. Calling attic on these
# returns the singleton class for each of them. But again
# a singleton class for each of them but again they all
#
# TrueClass.attic  #=> #<Class:TrueClass>
# FalseClass.attic #=> #<Class:FalseClass>
# NilClass.attic   #=> #<Class:NilClass>
#
#
# For comparison, here's what happens with a String (each
# time attic is called on a new string you get a new
# singleton)
#
# "".attic         #=> #<Class:#<String:0x0001234>>
# "".attic         #=> #<Class:#<String:0x0005678>>
# "".attic.object_id #=> 1234
# "".attic.object_id #=> 5678
#
# nil.attic        #=> NilClass
# nil.attic        #=> NilClass
# nil.attic.object_id #=> 800
# nil.attic.object_id #=> 800
#
module Attic
  VERSION = '1.0.0-RC3'.freeze unless defined?(VERSION)

  # A convenince method at the class level for including
  # ConstructMethods in the given object specifically.
  #
  #   e.g.
  #
  #     Add Attic support to all objects available now and
  #     in the future:
  #
  #       Attic.construct(Object)
  #
  #     which is equivalent to:
  #
  #       class Object; include Attic::ClassMethods; end
  #
  def self.construct(obj)
    obj.include Attic::ClassMethods
  end

  # Friendly exception to say we're not to be included
  #
  def self.included(obj)
    raise RuntimeError, "Did you mean to `extend Attic`` in #{obj}"
  end

  def self.extended(obj)
    # If the class has already been extended, we don't need
    # to add the class methods again.
    return if obj.ancestors.member? self

    # Add the instance methods for accessing attic variables
    obj.send :include, Attic::InstanceMethods

    # If the object doesn't have a dedicated singleton class
    # an exception will be raised so it can be caught and
    # handled appropriately.
    obj.attic.instance_variable_defined?("@attic_variables")

    obj.attic.instance_variable_set("@attic_variables", [])

    def obj.inherited(klass)
      super
      attic_vars = self.attic_variables.clone
      klass.attic.instance_variable_set("@attic_variables", attic_vars)
    end
    if obj.method_defined? :instance_variables
      instance_variables_orig = obj.instance_method(:instance_variables)
      obj.define_method :instance_variables do
        ret = instance_variables_orig.bind(self).call.clone
        ret.reject! { |v| v.to_s =~ /^@___?attic/ }  # match 2 or 3 underscores
        ret
      end
      obj.define_method :all_instance_variables do
        instance_variables_orig.bind(self).call
      end
    end

  rescue TypeError => e
    raise NoSingletonError, obj, caller
  end

  # A class method for defining variables to store in the attic.
  # * +names+ is a list of variables names. Accessor methods are
  #   created for each variable name in the list.
  #
  # Returns an Array of all attic variables for the current
  # class unless no arguments are given in which case it
  # returns its singleton.
  #
  # e.g.
  #
  #     String.extend Attic
  #     String.attic :timestamp
  #
  # In this example, attic created two instance methods:
  # * <tt>String#timestamp</tt> for getting the value
  # * <tt>String#timestamp</tt> for setting the value
  #
  def attic(*names)
    return singleton_class if names.empty?

    names.each do |name|
      next if attic_variable? name

      self.attic_variables << name

      unless method_defined?(name)
        define_method(name) do
          attic_variable_get name
        end
      end

      unless method_defined?("#{name}=")
        define_method("#{name}=") do |val|
          attic_variable_set name, val
        end
      end
    end

    attic_variables  # only after defining new attic vars
  end

  def attic?
    return false if NoSingletonError.member? self

    singleton_class?

  rescue TypeError
    NoSingletonError.add_member self
    false
  end

  # Returns an Array of attic variables for the current class.
  # e.g.
  #
  #     String.extend Attic
  #     String.attic :timestamp
  #     String.attic_variables     # => [:timestamp]
  #
  def attic_variables
    a = attic.instance_variable_get('@attic_variables')
    a ||= attic.instance_variable_set('@attic_variables', [])
    a
  end

  def attic_variable?(name)
    attic_variables.member? name
  end
end

# - Module#instance_method returns an UnboundMethod
#   - http://ruby-doc.org/core/classes/Module.html#M001659

# Add some candy when we're in irb
if defined?(IRB)
  require 'irb/completion'
  IRB.conf[:PROMPT][:ATTIC] = {
    PROMPT_I: "attic> ",
    PROMPT_S: "attic%l> ",
    PROMPT_C: "attic* ",
    RETURN:   "=> %s\n\n"
  }
  IRB.conf[:PROMPT_MODE] = :ATTIC
end
