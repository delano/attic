# Attic: A special place to store instance variables.

# = NoSingleton
#
class NoSingleton < RuntimeError
  unless defined?(MEMBERS)
    # An Array of classes which do not have singleton classes
    # (i.e. meta classes). This is used to prevent an exception
    # the first time a metaclass is accessed. It's populated
    # dynamically at start time by simply checking whether
    # the object has a singleton. This only needs to be done
    # once per class.
    #
    MEMBERS = Set.new # rubocop:disable Style/MutableConstant
  end


end

# = AtticObjectMethods
#
# Adds a few methods for accessing the metaclass of an
# object. We do this with great caution since the Object
# class is as global as it gets in Ruby.
#
# NOTE: This module can be included in the Object class
module AtticObjectMethods

  # A quick way to check if the current object already has a
  # dedicated singleton class. We want to know this because
  # this is where our attic variables will be stored.
  def attic?
    return false if NoSingleton::MEMBERS === self

    # NOTE: Calling this on an object for the first time lazily
    # creates a singleton class for itself. Another way of doing
    # the same thing is to attempt defining a singleton method
    # for the object. In either case, and exception is raised
    # if the object cannot have a dedicated singleton class.
    !self.singleton_class.nil?

  rescue TypeError
    NoSingleton::MEMBERS.merge [self]
    false
  end

  def attic
    raise NoSingleton, self, caller unless self.attic?

    self.singleton_class

  rescue TypeError
    NoSingleton::MEMBERS.merge [self]
  end

  # A convenient method for getting the metaclass of the current object.
  # i.e.
  #
  #     class << self; self; end;
  #
  # NOTE: Some Ruby class do not have meta classes (see: MEMBERS).
  # For these classes, this method returns the class itself. That means
  # the instance variables will be stored in the class itself.
  def metaclass
    if self.attic?
      class << self
        pp 1
        self
      end
    else
      pp 2
      self
    end
  end

  # A convenience method for ensuring that the metaclass of the current
  # object is returned.
  # def attic
  #   klass = self.class
  #   variable_name = "@@_attic_#{object_id}"

  #   unless klass.class_variable_defined?(variable_name)
  #     klass.class_variable_set(variable_name, klass.singleton_class)
  #   end

  #   klass.class_variable_get variable_name
  # end

  # Add an instance method called +name+ to metaclass for the current object.
  # This is useful because it will be available as a singleton method
  # to all subclasses too.
  def meta_def(name, &blk)
    meta_eval { define_method name, &blk }
  end
end


# = Attic
#
# A place to store instance variables.
#
module Attic
  VERSION = '0.6-RC1'.freeze unless defined?(VERSION)

  # = Attic::InstanceMethods
  #
  module InstanceMethods
    def attic_variables
      self.class.attic_variables
    end
    alias attic_vars attic_variables

    def attic_variable? name
      self.class.attic_variable? name
    end

    def attic_variable_set(name, val)
      attic_variables << name unless attic_variable? name
      attic.instance_variable_set("@___attic_#{name}", val)
    end

    def attic_variable_get(name)
      attic.instance_variable_get("@___attic_#{name}")
    end

    def get_binding
      binding
    end
  end

  def self.attic_variables
    @attic_variables
  end

  def self.included(o)
    raise "You probably meant to 'extend Attic' in #{o}"
  end

  def self.extended(o)
    # This class has already been extended.
    return if o.ancestors.member? Attic::InstanceMethods

    # Add the instance methods for accessing attic variables
    o.send :include, Attic::InstanceMethods

    o.metaclass.instance_variable_set("@attic_variables", [])
    o.class_eval do
      def self.inherited(klass)
        attic_vars = self.attic_variables.clone
        klass.metaclass.instance_variable_set("@attic_variables", attic_vars)
      end
      if method_defined? :instance_variables
        _instance_variables_orig = instance_method(:instance_variables)
        define_method :instance_variables do
          ret = _instance_variables_orig.bind(self).call.clone
          ret.reject! { |v| v.to_s =~ /^@___?attic/ }  # match 2 or 3 underscores
          ret
        end
        define_method :all_instance_variables do
          _instance_variables_orig.bind(self).call
        end
      end
    end
  end

  # A class method for defining variables to store in the attic.
  # * +names+ is a list of variables names. Accessor methods are
  #   created for each variable name in the list.
  #
  # Returns the list of attic variable names or if no names were
  # given, returns the metaclass.
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
  def attic *names
    return metaclass if names.empty?
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
    attic_vars
  end

  # Returns an Array of attic variables for the current class.
  # e.g.
  #
  #     String.extend Attic
  #     String.attic :timestamp
  #     String.attic_variables     # => [:timestamp]
  #
  def attic_variables
    a = metaclass.instance_variable_get('@attic_variables')
    a ||= metaclass.instance_variable_set('@attic_variables', [])
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
