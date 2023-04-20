#

# = Attic::InstanceMethods
#
module Attic
  # Adds a few methods for object instances to access the
  # attic variables of their class.
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
end
