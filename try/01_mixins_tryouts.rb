group "Mixins"
library :attic, 'lib'

tryouts "Object" do
  drill "has metaclass", 'Object' do
    Object.new.metaclass.superclass.to_s
  end
  
  drill "has metametaclass", '#<Class:Object>' do
    Object.new.metametaclass.superclass.to_s
  end
end