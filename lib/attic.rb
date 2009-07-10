
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
  
  def attic *junk
    return superclass.metaclass if junk.empty?

    attr_accessor *junk

    meta_def :initialize do
      junk.each do |a|
        
        meta_def a do
          instance_variable_get "@#{a}"
        end
        meta_def "#{a}=" do |val|
          instance_variable_set "@#{a}", val
        end
         
      end
    end
  end
  
end

# - Module#instance_method returns an UnboundMethod
#   - http://ruby-doc.org/core/classes/Module.html#M001659
