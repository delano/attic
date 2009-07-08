group "Attic"
library :attic, "lib"
tryouts "Basic API" do
  
  drill "can extend Attic", true do
    class ::Worker
      extend Attic
    end
    Worker.methods.member? :attic
  end
  
  drill "can't include Attic raises exception", :exception, RuntimeError do
    class ::Worker
      include Attic
      
      attic :hidden
    end
  end
  

  
  drill "save an instance variable the long way", 'S&F' do
    w = Worker.new
    w.metametaclass.instance_variable_set '@mattress', 'S&F'
    w.metametaclass.instance_variable_get '@mattress'
  end
  
  drill "instance variables are hidden", [] do
    w = Worker.new
    w.metametaclass.instance_variable_set '@mattress', 'S&F'
    w.instance_variables
  end
  
end