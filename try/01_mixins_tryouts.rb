group "Mixins"
library :attic, "lib"

tryouts "Object" do
  if Tryouts.sysinfo.ruby == "1.9.1"
    drill "has metaclass", 'Object' do
      Object.new.metaclass.superclass.to_s
    end
    drill "has metametaclass", '#<Class:Object>' do
      Object.new.metametaclass.superclass.to_s
    end
  end
end