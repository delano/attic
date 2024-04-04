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
      NoSingleton.add_member self
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
