
require 'attic/mixins'

# = Attic
#
# A place to store instance variables. 
#
module Attic
  VERSION = '0.3.1'
  
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
  
  # Create instance methods that store variables in the metaclass. 
  @@metaclass_proc = proc { |klass,name|
    klass.class_eval do
      # Add the attic variables named to the list. Notice that we
      # cheakily store this in the metameta class so as to not 
      # disturb the metaclass instance variables. 
      vars = attic_vars << name
      metametaclass.instance_variable_set("@attic", vars)
      
      define_method(name) do
        metaclass.instance_variable_get("@#{name}")
      end
      define_method("#{name}=") do |val|
        metaclass.instance_variable_set("@#{name}", val)
      end
    end
  }
  
  # Create instance methods that store variables in unlikely instance vars.
  @@nometaclass_proc = proc { |klass,name|
    klass.class_eval do
      # Add the attic variables named to the list. We use a 
      # variable with 3 underscores to prevent collisions. 
      vars = attic_vars << name
      instance_variable_set("@___attic_vars", vars)
      
      define_method(name) do
        instance_variable_get("@__attic_#{name}")
      end
      define_method("#{name}=") do |val|
        instance_variable_set("@__attic_#{name}", val)
      end
      define_method :instance_variables do |*args|
        ret = super *args
        ret.reject! { |v| v.to_s =~ /^@___?attic/ }  # match 2 or 3 underscores
        ret
      end
    end
  }

  
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
  # * <tt>String#timestamp</tt> for getting the value
  # * <tt>String#timestamp</tt> for setting the value
  #
  def attic *junk
    #p [:attic, self, metaclass?]
    return metaclass if junk.empty?
    
    processor = metaclass? ? @@metaclass_proc : @@nometaclass_proc
    
    junk.each do |var|
      processor.call(self, var)
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
    if metaclass?
      metametaclass.instance_variable_get("@attic") || []
    else
      instance_variable_get("@___attic_vars") || []
    end
  end
  
  
end

# - Module#instance_method returns an UnboundMethod
#   - http://ruby-doc.org/core/classes/Module.html#M001659
