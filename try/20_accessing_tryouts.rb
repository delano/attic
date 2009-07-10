group "Attic"
library :attic, "lib"
tryouts "Setting and Getting" do
  
  setup do
    class ::Worker
      extend Attic
      attic :size
    end
  end
  
  drill "save an instance variable the long way", 'S&F' do
    w = Worker.new
    w.metametaclass.instance_variable_set '@mattress', 'S&F'
    w.metametaclass.instance_variable_get '@mattress'
  end
  
  drill "save an instance variable the short way", :california_king do
    w = Worker.new
    w.size = :california_king
    w.size
  end
  
  drill "instance variables are hidden", [] do
    w = Worker.new
    w.metametaclass.instance_variable_set '@mattress', 'S&F'
    w.instance_variables
  end
  
  
end