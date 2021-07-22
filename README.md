# Attic - v0.6-RC1 (2021-07-01)

A place to hide private instance variables in your Ruby objects.

## Example

```ruby
    require 'attic'

    class String
      extend Attic
      attic :timestamp
    end

    a = "anything"
    a.timestamp = "1980-11-18"
    a.instance_variables                      # => []
    a.timestamp                               # 1980-11-18

    a.attic_variables                         # => [:timestamp]

    a.attic_variable_set :tags, [:a, :b, :c]
    a.attic_variable_get :tags                # [:a, :b, :c]

    a.attic_variables                         # => [:timestamp, :tags]
```

## Some objects have no metaclasses

Symbol objects do not have metaclasses so instance variables are hidden in the object itself.


## Installation

Via Rubygems, one of:

```shell
    $ gem install attic
```

or via download:
* attic-latest.tar.gz[http://github.com/delano/attic/tarball/latest]
* attic-latest.zip[http://github.com/delano/attic/zipball/latest]


== Credits

* `gems@solutious.com` (@delano)
