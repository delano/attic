group "Attic"
library :attic, "lib"
tryouts "Explicit accessors" do

  setup do
    class ::Worker
      extend Attic
    end
  end
  
  drill "can set value", 100 do
    a = Worker.new
    a.attic_variable_set :space, 100
    a.attic_variable_get :space
  end
  
  drill "doesn't create accessor methods", false do
    a = Worker.new
    a.attic_variable_set :space, 100
    a.respond_to? :space
  end
  
end