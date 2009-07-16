class NoMetaClass < RuntimeError
end

# = Object
#
# These methods are copied directly from _why's metaid.rb. 
# See: http://whytheluckystiff.net/articles/seeingMetaclassesClearly.html
class Object
  
  # An Array of classes which do not have metaclasses.
  NOMETACLASS = [Symbol, Fixnum].freeze
  
  def metaclass?
    !NOMETACLASS.member?(self)
  end
  
  # FIX: metaclass should check self or self.class? ??? Check previous version
  
  # A convenient method for getting the metaclass of the current object.
  # i.e.
  #
  #     class << self; self; end;
  #
  # NOTE: Some Ruby class do not have meta classes (see: NOMETACLASS). 
  # For these classes, this method returns the class itself. That means
  # the instance variables will stored in the class itself. 
  def metaclass
    if !self.class.metaclass?
      #raise NoMetaClass, self
      self.class
    else
      class << self; self; end; 
    end
  end

  # Execute a block +&blk+ within the metaclass of the current object.
  def meta_eval &blk; metaclass.instance_eval &blk; end
  
  # Add an instance method called +name+ to metaclass for the current object.
  # This is useful because it will be available as a singleton method
  # to all subclasses too. 
  def meta_def name, &blk
    meta_eval { define_method name, &blk }
  end
  
  # Add a class method called +name+ for the current object's class. This
  # isn't so special but it maintains consistency with meta_def. 
  def class_def name, &blk
    class_eval { define_method name, &blk }
  end

  
  # A convenient method for getting the metaclass of the metaclass
  # i.e.
  #
  #     self.metaclass.metaclass
  #
  def metametaclass; self.metaclass.metaclass; end

  def metameta_eval &blk; metametaclass.instance_eval &blk; end

  def metameta_def name, &blk
    metameta_eval { define_method name, &blk }
  end
  
end
