#
# = Attic::ClassMethods
#
module Attic
  # Adds a few methods for accessing the metaclass of an
  # object. We do this with great caution since the Object
  # class is as global as it gets in Ruby.
  module ClassMethods
    # A list of all the attic variables defined for this class.
    attr_reader :attic_variables

    # A quick way to check if the current object already has a
    # dedicated singleton class. We want to know this because
    # this is where our attic variables will be stored.
    def attic?
      return false if NoSingletonError.member? self

      # NOTE: Calling this on an object for the first time lazily
      # creates a singleton class for itself. Another way of doing
      # the same thing is to attempt defining a singleton method
      # for the object. In either case, objects that cannot have
      # cannot have a dedicated singleton class (e.g. nil, true,
      # false) will raise a TypeError. We rescue this and add the
      # object to the NoSingletonError list so we don't have to
      # keep trying to access its singleton class.
      !singleton_class.nil?

    rescue TypeError
      # Remember for next time.
      NoSingletonError.add_member self
      false
    end

    def attic(name=nil)
      return singleton_class if name.nil?

      name = name.normalize

      self.attic_variables << name unless attic_variable? name

      safe_name = "@_attic_#{name}"
      instance_variable_set(safe_name, name)
    end

    def attic_variable?(name)
      attic_variables.include? name.normalize
    end

    def attic_variable_set(name, val)
      unless attic_variable? name
        attic_variables << name.normalize
      end
      attic.instance_variable_set("@_attic_#{name}", val)
    end

    def attic_variable_get(name)
      instance_variable_get("@_attic_#{name}")
    end

    protected

    def normalize(name)
      name.to_s.gsub(/\@[\?\!\=]$/, '_').to_sym
    end
  end
end
