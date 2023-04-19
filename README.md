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

Symbol, Integer, Float, TrueClass, FalseClass, NilClass, and Fixnum are all objects that do not have singleton classes. TrueClass, FalseClass, and NilClass are all singletons themselves. Fixnum is a singleton of Integer.

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


## Credits

* (@delano) Delano Mandelbaum


## License

MIT
