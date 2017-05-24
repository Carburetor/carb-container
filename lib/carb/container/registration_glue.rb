require "carb"
require "carb/container/registerer"
require "forwardable"

module Carb::Container
  # Provides a method hook in all classes to register them as injectable
  class RegistrationGlue
    # Creates a new class method {Class#carb_container} which can be used as
    # a macro to easily register objects into the supplied container
    # @param container [#register] a generic object, usually a
    #   {RegistryContainer} which responds to `#register(name, dependency)`,
    #   it's the only required argument
    # @param target [Object] class where you want to add the class method
    #   `carb_container`. Usually it's {::Class} itself
    # @param registerer [Module] subclass of a module which can be included.
    #   Usually it's {Registerer} which is an internal module used to store
    #   objects inside a container which responds to `#register`
    # @param converter [#call] Object which accepts a string and converts it
    #   into a valid method name. It's used to convert class name to a method
    #   name. By default it uses {ClassNameToMethodName}
    def call(
      container,
      target:     Class,
      registerer: Registerer,
      converter:  ClassNameToMethodName.new
    )
      target.send(:include, registerer.new(container, converter: converter))
    end

    class << self
      extend Forwardable

      def_delegators :new, :call
    end
  end
end
