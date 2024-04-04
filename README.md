# Attic - v0.5

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

Symbol and Fixnum objects do not have metaclasses so instance variables are hidden in the object itself.


## Installation

Via Rubygems, one of:

```bash
    $ gem install attic
```
