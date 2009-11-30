group "Attic"
library :attic, "lib"
tryouts "Basics" do
  
  drill "can extend Attic", true do
    class ::Worker
      extend Attic
    end
    # 1.9                             # 1.8
    Worker.methods.member?(:attic) || Worker.methods.member?('attic')
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
    stash :instance_methods, Worker.instance_methods(false)
    stash :metamethods, Worker.methods.sort
    w.respond_to? :size
  end
  
  drill "can access attic attributes explicitly", 2 do
    w = Worker.new
    w.attic_variable_set :size, 2
    w.attic_variable_get :size
  end
  
end


