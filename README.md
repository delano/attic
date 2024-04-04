# Attic - v0.6-RC1 (2023-04-19)

A place to hide private instance variables in your Ruby objects: in the attic.


## Example

```ruby
    require 'attic'

    class String
      extend Attic
      attic :timestamp
    end

    a = "anything"
    a.timestamp = "1990-11-18"
    a.instance_variables                      # => []
    a.timestamp                               # 1990-11-18

    a.attic_variables                         # => [:timestamp]

    a.attic_variable_set :tags, [:a, :b, :c]
    a.attic_variable_get :tags                # [:a, :b, :c]

    a.attic_variables                         # => [:timestamp, :tags]
```

## More details

### Objects without singleton classes

Symbol, Integer, Float, TrueClass, FalseClass, NilClass, and Fixnum are all objects that do not have singleton classes. TrueClass, FalseClass, and NilClass are all singletons themselves. Fixnum is a singleton of Integer.

These objects do not have metaclasses so the attic is hidden in the object itself.

### Play around with it

```shell
    $ irb -r attic
```

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
