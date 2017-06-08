# Carb::Container

A set of simple container objects to store dependencies. Can be used in
conjuction with [carb-inject](https://github.com/Carburetor/carb-inject) as
an IoC container.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'carb-container'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install carb-container

## Usage

There are 3 containers available, one interface to create custom containers and
a utility class that helps you register classes inside the container.

### Carb::Container::Base

This is a simple module that is an interface. Has two methods which must both
be provided by the developer:

- `[](name)` which is the method used to get dependencies. If you need to raise
  an error because dependency is missing, you can use
  `Carb::Container::DependencyMissingError` which accepts the dependency name
  in the constructor (to improve the error message)
- `has_key?(name)` which is the method used to check if the key exists on a
  given container

### Carb::Container::RegistryContainer

This is the main container and probably the only one you will be using. It
respects the `Carb::Container::Base` interface.
It stores dependencies (with some utilities) in a hashmap and can be fetched
back with `#[]` which raises `Carb::Container::DependencyMissingError` in
case no dependency is found. To register a dependency you simply call
`#register(name, dependency_enclosed_in_proc)` and it will be stored inside.

```ruby
class MyClass
  def hello
    puts "hi"
  end
end

container = Carb::Container::RegistryContainer.new
container.register(:my_class, -> { MyClass })

container[:my_class].new.hello
```

### Carb::Container::RegistrationGlue

A utility class that makes the method `carb_container` available as class 
class method in all classes so, that you can easily register any newly
created class. This is entirely optional, for people who don't like monkey
patching, can be skipped.

```ruby
MyContainer = Carb::Container::RegistryContainer.new
Carb::Container::RegistrationGlue.call(MyContainer)

module My
  class Person
    carb_container

    def greet
      puts "hi"
    end
  end
end

class Dog
  carb_container as: :special_dog

  def bark
    puts "woff"
  end
end

person = MyContainer[:my_person].new
dog    = MyContainer[:special_dog].new

person.greet
person.bark
```

#### carb_container

This method accepts two options:

- `as:` which accepts a `Symbol` and is the name which will be used to
  register the class. If not supplied and `activesupport` is present, it will
  be inferred by class name in snake_case
- `initialize: false` by default the value is the same as the `initialize`
  supplied to `RegistrationGlue` when invoked (which defaults to `false`).
  When false, it will register the class itself as is, equivalent to calling
  `mycontainer.register(:foo, -> { Foo })`, however if set to `true` it
  store the dependency with a call to `new`, like
  `mycontainer.register(:foo, -> { Foo.new })`, the class must have a
  constructor without arguments

`RegistrationGlue` also accepts an option when called:

- `initialize: false` which can be set to `true` so that `carb_container` will
  automatically supply `initialize: true` instead (check `carb_container` for
  more details)

At this point, `carb_container` method

### Carb::Container::DelegateContainer

Special container which allows chaining containers together so that a
dependency not found in the first one, is searched in the subsequent ones. If
no dependency is found, `Carb::Container::DependencyMissingError` is raised.

```ruby
Container1 = Carb::Container::RegistryContainer.new
Container2 = Carb::Container::RegistryContainer.new
Delegate = Carb::Container::DelegateContainer.new([Container1, Container2])

class Person
  def greet
    puts "hello"
  end
end

class Dog
  def bark
    puts "woff"
  end
end

Container1.register(:person, -> { Person })
Container2.register(:dog, -> { Dog })

Delegate[:dog] == Dog # => true
Delegate[:person] == Person # => true

Delegate[:foo] # raises DependencyMissingError
```

### Carb::Container::ErrorContainer

Special container which doesn't allow to register any dependency, always
raises `Carb::Container::DependencyMissingError` and always returns `false`
for `has_key?` method. It's only useful within the DelegateContainer or as a
null object (as in null object pattern).

```ruby
container = Carb::Container::ErrorContainer.new

container[:foo] # raises DependencyMissingError
container.has_key?(:bar) # => false
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Carburetor/carb-container.

