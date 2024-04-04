#

# = Attic::InstanceMethods
#
module Attic
  # Adds a few methods for object instances to access the
  # attic variables of their class.
  module InstanceMethods

    def attic
      raise NoSingletonError, self, caller unless attic?

      singleton_class

    rescue TypeError
      NoSingletonError.add_member self
    end

    # A quick way to check if this object instance already has a
    # dedicated singleton class. We like to know this upfront
    # because this is where our attic variables are to be stored.
    def attic?
      return false if NoSingletonError.member? self

      # NOTE: Calling this on an object for the first time lazily
      # creates a singleton class for itself. Another way of doing
      # the same thing is to attempt defining a singleton method
      # for the object. In either case, objects that cannot have
      # cannot have a dedicated singleton class (e.g. nil, true,
      # false) will raise a TypeError. We rescue this and add the
      # object to the NoSingletonError list so we don't keep
      # trying to access its singleton class over and over.
      #
      # NOTE 2: Module#singleton_class? is only available for
      # modules and classes (which are also modules); it is not
      # available for instances of classes.
      #
      !singleton_class.nil?

    rescue TypeError
      # Remember for next time.
      NoSingletonError.add_member self
      false
    end

    def attic_variables
      self.class.attic_variables
    end

    def attic_variable?(name)
      self.class.attic_variable? name
    end

    def attic_variable_set(name, val)
      attic_variables << name unless attic_variable? name
      attic.instance_variable_set("@___attic_#{name}", val)
    end

    def attic_variable_get(name)
      attic.instance_variable_get("@___attic_#{name}")
    end
  end
end
