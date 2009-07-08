
require 'attic/mixins'

# = Attic
#
# A place to store instance variables. 
#
module Attic
  VERSION = 0.2
  
  def attic; self.metaclass.metaclass; end
  
end
