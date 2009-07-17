group "No Meta Class"
library :attic, 'lib'
tryouts "Basics" do
  
  dream :class, Array
  dream [Symbol, Fixnum]
  drill "has list of no metaclass classes" do
    Object::NOMETACLASS
  end
  
  dream :exception, NoMetaClass
  drill "Symbol metaclass raises exception" do
   :any.metaclass
  end
  
  ## NOTE: fails
  drill "Symbol instances don't cross streams", [:roger, nil] do
    Symbol.extend Attic
    Symbol.attic :name
    a = :any
    a.name = :roger
    [a.name, :another.name]
  end
  
  drill "metaclass? method exists", true do
    Symbol.extend Attic
    :any.respond_to? :metaclass?
  end
  
  drill "metaclass? method is false for a Symbol", false do
    :any.class.metaclass?
  end
  
end