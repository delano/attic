group "Attic"
library :attic, "lib"
tryouts "Basic API" do
  
  drill "Can include Attic", true do
    class ::Worker
      include Attic
    end
  end
  
  drill "has metaclass", true do
    ::Worker.new.metaclass
  end
  
  drill "has attic", true do
    ::Worker.new.attic
  end
  
  
end