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

Now `take` safely defined values by argument with its `Symbol` or `String` type. If there is no defined such value `Enum::TokenNotFoundError` exception will be raised. And this is the **safety** - you will be noticed about the problem and fix it by introducing a new value or fixing a source of the invalid value. While others implementations of enums in Ruby (that I know) just silently ignore invalid values returing `nil` this one will raise the exception **always**. Example of usage:

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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mezuka/enum. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

