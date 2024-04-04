# Attic - v1.0-RC1 (2023-03-15)

A place to hide private instance variables in your Ruby objects: in the attic.

## Description

Attic is a Ruby library that provides a place to hide private instance variables in your Ruby objects: in the attic.

Like, _why though_? Well sometimes you want to hide thing from the public interface of your object. You could use the `@@` prefix to place them at the class level but then you can't use them on a per-instance basis without creating a new data structure to store them. Attic does this for you in a transparent way using the Ruby singleton classes that are already there**.


### Example

```ruby
    require 'attic'

    # Extend a class with Attic
    class String
      extend Attic

      # Add an instance variable to the attic. All instances
      # of this class will have this variable available.
      attic :timestamp
    end

    # Instantiate a new String object
    a = "A lovely example of a string"

    # Set and get the timestamp
    a.timestamp = "1990-11-18"
    a.timestamp                               # => "1990-11-18"

    # The timestamp is not visible in the public interface
    a.instance_variables                      # => []

    # But it is available in the attic
    a.attic_variables                         # => [:timestamp]

    # If you prefer getting your hands dirty, you can also
    # interact with the attic at a lower level.
    a.attic_variable_set :tags, [:a, :b, :c]
    a.attic_variable_get :tags                # => [:a, :b, :c]

    # Looking at the attic again shows that the timestamp
    # is still there too.
    a.attic_variables                         # => [:timestamp, :tags]
```


### **Objects without singleton classes

Symbol, Integer, Float, TrueClass, FalseClass, NilClass, and Integer are all objects that do not have singleton classes. TrueClass, FalseClass, and NilClass are all singletons themselves. Integer is a singleton of Integer.

These objects do not have metaclasses so the attic is hidden in the object itself.

### Explore in irb

```shell
    $ irb -r attic
```

---

## Installation

```shell
    $ gem install attic
```

```shell
    $ bundle install attic
```

or via download:
* [attic-latest.tar.gz](https://github.com/delano/attic/tarball/latest)
* [attic-latest.zip](https://github.com/delano/attic/zipball/latest)


## Proofs

Tested the following code in IRB for Ruby 2.6.8 and 3.0.2:

```ruby
    rquire 'pp'

    test_values = [:sym, 1, 1.01, Symbol, Integer, Float, String, TrueClass, FalseClass, NilClass, '', true, false, nil]

    results = test_values.map do |value|
      { value: value,
        class: value.class,
        attic: [value.attic?, value.attic? && value.attic.object_id] }
    end
```

which produced the same results for both.

```ruby
    attic> RUBY_VERSION
    => "3.2.0"

    pp results
    [
      {:value=>:sym,        :class=>Symbol,       :attic=>[false, false]},
      {:value=>1,           :class=>Integer,      :attic=>[false, false]},
      {:value=>1.01,        :class=>Float,        :attic=>[false, false]},
      {:value=>Symbol,      :class=>Class,        :attic=>[true, 564680]},
      {:value=>Integer,     :class=>Class,        :attic=>[true, 564700]},
      {:value=>Float,       :class=>Class,        :attic=>[true, 564720]},
      {:value=>String,      :class=>Class,        :attic=>[true, 564740]},
      {:value=>TrueClass,   :class=>Class,        :attic=>[true, 564760]},
      {:value=>FalseClass,  :class=>Class,        :attic=>[true, 564780]},
      {:value=>NilClass,    :class=>Class,        :attic=>[true, 564800]},
      {:value=>"",          :class=>String,       :attic=>[true, 602880]}
      {:value=>true,        :class=>TrueClass,    :attic=>[true, 13840]},
      {:value=>false,       :class=>FalseClass,   :attic=>[true, 13860]},
      {:value=>nil,         :class=>NilClass,     :attic=>[true, 40]}
    ]
```
```ruby
    attic> RUBY_VERSION
    => "2.6.8"

    pp results
    [
      {:value=>:sym,        :class=>Symbol,       :attic=>[false, false]},
      {:value=>1,           :class=>Integer,      :attic=>[false, false]},
      {:value=>1.01,        :class=>Float,        :attic=>[false, false]},
      {:value=>Symbol,      :class=>Class,        :attic=>[true, 2844115920]},
      {:value=>Integer,     :class=>Class,        :attic=>[true, 2844089400]},
      {:value=>Float,       :class=>Class,        :attic=>[true, 2844087700]},
      {:value=>String,      :class=>Class,        :attic=>[true, 2844122580]},
      {:value=>TrueClass,   :class=>Class,        :attic=>[true, 2844136260]},
      {:value=>FalseClass,  :class=>Class,        :attic=>[true, 2844136000]},
      {:value=>NilClass,    :class=>Class,        :attic=>[true, 2844139060]},
      {:value=>"",          :class=>String,       :attic=>[true, 2845261220]},
      {:value=>true,        :class=>TrueClass,    :attic=>[true, 2844136280]},
      {:value=>false,       :class=>FalseClass,   :attic=>[true, 2844136020]},
      {:value=>nil,         :class=>NilClass,     :attic=>[true, 2844139080]}
    ]
```

## Credits

* (@delano) Delano Mandelbaum


## License

MIT
