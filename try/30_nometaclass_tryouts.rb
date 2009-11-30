group "No Meta Class"
library :attic, "lib"
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
  
  drill "Symbol instances don't cross streams", [:roger, nil] do
    Symbol.extend Attic
    Symbol.attic :name
    a, b = :symbol1, :symbol2
    a.name = :roger
    [a.name, b.name]
  end
  
  drill "metaclass? method exists", true do
    Symbol.extend Attic
    :any.respond_to? :metaclass?
  end
  
  drill "metaclass? method is false for a Symbol", false do
    :any.metaclass?
  end
  
  dream [:@___attic_name]
  drill "A Symbol's attic vars appear in all_instance_variables" do
    Symbol.extend Attic
    Symbol.attic :name
    a, b = :symbol1, :symbol2
    a.name = :roger
    a.all_instance_variables
  end
  
  dream []
  drill "A Symbol's attic vars do not appear in instance_variables" do
    Symbol.extend Attic
    Symbol.attic :name
    a, b = :symbol1, :symbol2
    a.name = :roger
    a.instance_variables
  end
  
  
end