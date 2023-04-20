# Attic: A special place to store instance variables.

# = NoSingleton
#
class NoSingleton < RuntimeError
  unless defined?(MEMBERS)
    # A Set of classes which do not have singleton classes
    # (i.e. meta classes). This is used to prevent an exception
    # the first time an attic is accessed. It's populated
    # dynamically at start time by simply checking whether
    # the object has a singleton. This only needs to be
    # done once per class.
    #
    # We use a set here to avoid having to deal with duplicate
    # values. Realistically there are only a few classes that
    # do not have singleton classes. We could hard code them
    # here which is not lost on us.
    #
    MEMBERS = Set.new
  end

  # Check if the given object is a member of the NoSingleton
  # members list. This checks for the object itself and all
  # of its ancestors. See the docs for `Enumerable#===` for
  # more details.
  def self.member?(obj)
    MEMBERS === obj
  end

  def self.add_member(obj)
    MEMBERS.merge [self]
  end
end

# = Attic
#
# Usage:
#  require 'attic'
#  class MyClass
#    include Attic
#   attic :name, :age
#  end
#
#
#
#
# A few important notes: some objects are not capable of
# constructing an attic. These are objects that do not have
# a dedicated singleton class.
#
#
# Calling attic on `Symbol, Integer, Float` are what ruby
# internals refer to as "immediate values". They're special
# in that they are not objects in the traditional sense.
# They're just values (they're not even instances of a
# class 😮‍💨).
#
# :sym.attic       #=> raises NoSingleton error
# 1.attic          #=> Ditto
# 1.0.1.attic      #=> Ditto again
#
#
# Calling attic on `true, false, and nil` return their
# class. Note: this means that they all share the same
# "attic" class.
#
# true.attic       #=> TrueClass
# false.attic      #=> FalseClass
# nil.attic        #=> NilClass
#
#
# The behaviour is similar with NilClass, TrueClass,
# and FalseClass. Calling attic on these classes returns
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
  VERSION = '0.6-RC1'.freeze unless defined?(VERSION)

  # = Attic::InstanceMethods
  #
  module InstanceMethods
    # def attic_variables
    #   self.class.attic_variables
    # end
    # alias attic_vars attic_variables

    # def attic_variable?(name)
    #   self.class.attic_variable? name
    # end
    # alias attic_var? attic_variable?

    # def attic_variable_set(name, val)
    #   attic_variables << name unless attic_variable? name
    #   attic.instance_variable_set("@___attic_#{name}", val)
    # end
    # alias attic_var_set attic_variable_set

    # def attic_variable_get(name)
    #   attic.instance_variable_get("@___attic_#{name}")
    # end
    # alias attic_var_get attic_variable_get
  end

  # = Attic::ConstructionMethods
  #
  # Adds a few methods for accessing the metaclass of an
  # object. We do this with great caution since the Object
  # class is as global as it gets in Ruby.
  #
  module ClassMethods
    # A list of all the attic variables defined for this class.
    attr_reader :attic_variables

    # A quick way to check if the current object already has a
    # dedicated singleton class. We want to know this because
    # this is where our attic variables will be stored.
    def attic?
      return false if NoSingleton.member? self

      # NOTE: Calling this on an object for the first time lazily
      # creates a singleton class for itself. Another way of doing
      # the same thing is to attempt defining a singleton method
      # for the object. In either case, and exception is raised
      # if the object cannot have a dedicated singleton class.
      !self.singleton_class.nil?

    rescue TypeError
      # Remember for next time.
      NoSingleton.add_member self
      false
    end

    def attic(name)
      name = name.normalize

      self.attic_variables << name unless attic_variable? name

      _safe_name = "@_attic_#{name}"
      instance_variable_set(_safe_name, name)
    end

    def attic_variable?(name)
      attic_variables.include? name.normalize
    end

    def attic_variable_set(name, val)
      unless attic_variable? name
        self.attic_variables << name.normalize
      end
      attic.instance_variable_set("@_attic_#{name}", val)
    end

    def attic_variable_get(name)
      instance_variable_get("@_attic_#{name}")
    end

    protected

    def normalize(name)
      name.to_s.gsub(/\@[\?\!\=]$/, '_').to_sym
    end
    # def attic
    #   raise NoSingleton, self, caller unless attic?
    #
    #   singleton_class
    #
    # rescue TypeError
    #   NoSingleton.add_member self
    # end
  end

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
  #       class Object; include AtticObjectMethods; end
  #
  def self.construct(obj)
    obj.include AtticObjectMethods
  end

  def self.included(obj)
    raise Runtime, "Did you to `extend Attic`` in #{obj}"
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
    if method_defined? :instance_variables
      instance_variables_orig = instance_method(:instance_variables)
      define_method :instance_variables do
        ret = _instance_variables_orig.bind(self).call.clone
        ret.reject! { |v| v.to_s =~ /^@___?attic/ }  # match 2 or 3 underscores
        ret
      end
      define_method :all_instance_variables do
        _instance_variables_orig.bind(self).call
      end
    end

  rescue TypeError => e
    raise NoSingleton, obj, caller
  end

  # A class method for defining variables to store in the attic.
  # * +names+ is a list of variables names. Accessor methods are
  #   created for each variable name in the list.
  #
  # Returns the list of attic variable names or if no names were
  # given, returns the attic.
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
    return attic_variables if names.empty?

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

    attic_variables
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
  alias attic_vars attic_variables

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
