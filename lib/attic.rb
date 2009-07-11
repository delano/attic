
require 'attic/mixins'

# = Attic
#
# A place to store instance variables. 
#
module Attic
  VERSION = 0.2
  
  def self.included(o)
    raise "You probably meant to 'extend Attic' in #{o}"
  end
  
  def self.extended(o)
    ## NOTE: This is just a reminder for a more descerning way to 
    ## include the meta methods, instead of using a global mixin. 
    ##o.class_eval do
    ##  include ObjectHelpers
    ##end
    
    # Create an instance method that returns the attic variables. 
    o.class_eval do
      define_method :attic_vars do
        self.class.attic_vars
      end
    end
  end
  
  # A class method for defining variables to store in the attic. 
  # * +junk+ is a list of variables names. Accessor methods are 
  #   created for each variable name in the list. 
  # 
  # Returns the list of attic variable names or if not junk was
  # given, returns the metaclass. 
  #
  # e.g.
  #  
  #     String.extend Attic
  #     String.attic :timestamp
  #
  # In this example, attic created two instance methods:
  # * +String#timestamp+ for getting the value
  # * +String#timestamp+ for setting the value
  #
  def attic *junk
    return metaclass if junk.empty?
    
    # Add the attic variables named to the list. Notice that we
    # cheakily store this in the metameta class so as to not 
    # disturb the metaclass instance variables. 
    metametaclass.instance_variable_set("@attic", [attic_vars, *junk].flatten)
    
    junk.each do |name|
      class_eval do
        define_method(name) do
          metaclass.instance_variable_get("@#{name}")
        end
        define_method("#{name}=") do |val|
          metaclass.instance_variable_set("@#{name}", val)
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
  #     String.attic_vars           # => [:timestamp]
  #
  def attic_vars
    metametaclass.instance_variable_get("@attic") || []
  end
  
  
end

# - Module#instance_method returns an UnboundMethod
#   - http://ruby-doc.org/core/classes/Module.html#M001659
