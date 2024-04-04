

# "".has_singleton_class? # => true
# :"".has_singleton_class? # => false
# 1.has_singleton_class? # =>
# nil.has_singleton_class? # => false
# NilClass.has_singleton_class? # => true

# members = ["", :food, 1, 1.00000001, nil, NilClass, true, TrueClass]
# members2 = members.clone

# members.each_with_index do |member, idx|
#   puts "member: #{member.inspect}"
#   member2 = members2[idx]

#   member.has_a_dedicated_singleton_class?  # => false
#   member2.has_a_dedicated_singleton_class?  # => false
#   member.bestow_a_singleton_class!
#   member.has_a_dedicated_singleton_class?  # => true
#   member2.has_a_dedicated_singleton_class?  # => false
#   member2.bestow_a_singleton_class!
#   member2.has_a_dedicated_singleton_class?  # => true

#   member.singleton_class.object_id # => 600
#   member2.singleton_class.object_id # => 700

#   member.has_method?(:foo) # => false
#   member.foo # => NoMethodError
#   member.add_to_singleton_class(:foo)
#   member.has_method?(:foo) # => true
#   member.foo = :bar
#   member.foo # => :bar
#   member.foo.object_id # => 601

#   member2.has_method?(:foo) # => false
#   member2.foo # => NoMethodError
#   member2.add_to_singleton_class(:foo)
#   member2.has_method?(:foo) # => true
#   member2.foo = :bar
#   member2.foo # => :bar
#   member2.foo.object_id # => 701

#   member2.foo.object_id == member.foo.object_id # => false
# end
