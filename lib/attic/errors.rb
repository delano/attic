
# Attic: A special place to store instance variables.

# = NoSingletonError
#
# This error is raised when an attempt is made to access the
# attic of an object which does not have a singleton class.
#
# This is a RuntimeError because it is not an exceptional
# condition. It is simply a condition that is not supported
# by the Attic module.
#
# == Usage
#
#   require 'attic'
#   class MyClass
#     include Attic
#     attic :name, :age
#   end
#
class NoSingletonError < RuntimeError
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
