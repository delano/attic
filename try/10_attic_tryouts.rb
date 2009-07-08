group "Attic"
library :attic, "lib"
tryouts "Basic API" do
  
  drill "Can include Attic", true do
    class ::Worker
      include Attic
    end
    Worker.instance_methods.member? :attic
  end
  
  drill "has metaclass", 'Worker' do
    Worker.new.metaclass.superclass.to_s
  end
  
  drill "has attic", '#<Class:Worker>' do
    Worker.new.attic.superclass.to_s
  end
  
  drill "save an instance variable the long way", 'S&F' do
    w = Worker.new
    w.attic.instance_variable_set '@mattress', 'S&F'
    w.attic.instance_variable_get '@mattress'
  end
  
  drill "instance variables are hidden", [] do
    w = Worker.new
    w.attic.instance_variable_set '@mattress', 'S&F'
    w.instance_variables
  end
  
end