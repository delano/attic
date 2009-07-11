group "Attic"
library :attic, "lib"
tryouts "String Setting and Getting" do

  drill "String can extend Attic", true do
    String.extend Attic
    String.respond_to? :attic
  end
  
  drill "save an instance variable the long way", 'S&F' do
    s = ""
    s.metametaclass.instance_variable_set '@mattress', 'S&F'
    s.metametaclass.instance_variable_get '@mattress'
  end

  drill "can create attributes", [:goodies] do
    String.attic :goodies
  end
  
  drill "save an instance variable the short way", :california_king do
    s = ""
    s.goodies = :california_king
    stash :ivars, s.instance_variables
    stash :avars, s.attic_vars
    s.goodies
  end
  
  drill "String instances don't cross streams", false do
    String.extend Attic
    String.attic :name
    a = "any"
    a.name = :roger
    a.name == "".name
  end
  
  
      
end