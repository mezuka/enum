![Travis](https://travis-ci.org/mezuka/enum.svg)
# Enum

This is a very basic implementation of enums in Ruby. The cornerstone of the library is **safety**.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'safe-enum', require: 'enum'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install safe-enum

## Usage

Define set of enums with code like this:
```ruby
class Side < Enum::Base
  values :left, :right
end
```

Now `take` safely defined values by argument with its `Symbol` or `String` type. If there is no defined such value `Enum::TokenNotFoundError` exception will be raised. And this is the **safety** - you will be noticed about the problem and fix it by introducing a new value or fixing a source of the invalid value. While others implementations of enums in Ruby (that I know) just silently ignore invalid values returning `nil` this one will raise the exception **always**. Example of usage:

```ruby
Side.take(:left) # => "left"
Side.take('left') # => "left"
Side.take(:invalid) # => Enum::TokenNotFoundError: token 'invalid'' not found in the enum Side
Side.take('invalid') # => Enum::TokenNotFoundError: token 'invalid'' not found in the enum Side
```

If you have installed `I18n` in your application feel free to use `name` method to retreive the values' translations. For the given example the possible translation structure in `yml` format is the following:

```yml
en:
  enum:
    Side:
      left: 'Left'
      right: 'Right'
```

The `name` method usage example:

```ruby
Side.name(:left) # => "Left"
Side.name('left') # => "Left"
Side.name(:right) # => "Right"
Side.name('right') # => "Right"
Side.name(:invalid) # => Enum::TokenNotFoundError: token 'invalid'' not found in the enum Side
```

> If you don't have installed `I18n` in your project `NameError` exception will be raised on the `name` method call.

Consider the case when we have an object with a field with only enum values. Extend the class of this object by `Enum::Predicates` and use `enumerize` method to generate predicates. This is a more convenient way matching current value of the field with an enum value. Usage the predicate methods is **safe** also. It means that you can't pass to the method invalid enum value neither can have an invalid value in the field:

```ruby
class Table
  extend Enum::Predicates

  attr_accessor :side

  enumerize :side, Side
end

@table = Table.new
@table.side_is?(:left) # => false
@table.side_is?(nil) # => false

@table.side = Side.take(:left)
@table.side_is?(:left) # => true
@table.side_is?(:right) # => false
@table.side_is?(nil) # => false
@table.side_is?(:invalid) # => Enum::TokenNotFoundError: token 'invalid'' not found in the enum Side

@table.side = 'invalid'
@table.side_is?(nil) # => false
@table.side_is?(:left) # => Enum::TokenNotFoundError: token 'invalid'' not found in the enum Side
```
> If you pass to the predicate `nil` or have `nil` value in the field the result will be always `false`. If you want to check that the field is `nil` just use Ruby's standard method `nil?`.

It's possible to get index of an enum value with `index` method. It can be convenient in some circumstances:

```ruby
class WeekDay < Enum::Base
  values :sunday, :monday, :tuesday, :wednesday, :thusday, :friday, :saturday
end
WeekDay.index(:sunday) == Date.new(2015, 9, 13).wday # => true
WeekDay.index(:monday) # => 1
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mezuka/enum. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

