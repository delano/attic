
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
    return metametaclass if junk.empty?
    
    junk.each do |a|
      metameta_def a do
        instance_variable_get "@#{a}"
      end
      metameta_def "#{a}=" do |val|
        instance_variable_set "@#{a}", val
      end
    end
  end
  
end

# - Module#instance_method returns an UnboundMethod
#   - http://ruby-doc.org/core/classes/Module.html#M001659
