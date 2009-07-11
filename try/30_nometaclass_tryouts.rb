group "No Meta Class"
library :attic, 'lib'
tryouts "Basics" do
  
  dream :class, Array
  dream [Symbol, Fixnum]
  drill "has list of no metaclass classes" do
    Object::NOMETACLASS
  end
  
  drill "Symbol metaclass returns Symbol", Symbol do
    :any.metaclass
  end
  
  drill "Symbol instances don't cross streams", true do
    Symbol.extend Attic
    Symbol.attic :name
    a = :any
    a.name = :roger
    [a.name, :another.name]
  end
  
  drill "String instances don't cross streams", false do
    String.extend Attic
    String.attic :name
    a = "any"
    a.name = :roger
    a.name == "".name
  end
  
end