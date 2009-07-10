group "Attic"
library :attic, "lib"
tryouts "Basics" do
  
  drill "can extend Attic", true do
    class ::Worker
      extend Attic
    end
    Worker.methods.member? :attic
  end
  
  drill "can't include Attic raises exception", :exception, RuntimeError do
    class ::Worker
      include Attic
    end
  end
  
  drill "can define attic attribute", true do
    Worker.attic :size
    w = Worker.new
    #w.attic :size
    stash :methods, w.methods.sort
    stash :metamethods, Worker.methods.sort
    w.respond_to? :size
  end
  
  drill "has size" do
  end
  
end

