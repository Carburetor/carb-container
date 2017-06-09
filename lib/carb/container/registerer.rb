require "carb"
require "carb/container/class_name_to_method_name"

module Carb::Container
  # Provides a class method to register classes globally
  class Registerer < Module
    private

    attr_reader :container
    attr_reader :init
    attr_reader :converter

    # @param container [#register] object which will be used to register
    #   dependencies as {::Proc}
    # @param init [Boolean] defaults to `false`. If `true`, carb_container will
    #   register classes as `-> { MyClass.new }` instead of `-> { MyClass }`
    # @param converter [#call] object which accepts a string and converts it
    #   into a valid method name. It's used to convert class name to a method
    #   name. By default it uses an instance of {ClassNameToMethodName}
    def initialize(
      container,
      init:      false,
      converter: ClassNameToMethodName.new
    )
      @container = container
      @init      = init
      @converter = converter
      def_carb_container(container, init, converter)
    end

    private

    def def_carb_container(kontainer, auto_init, convert)
      define_method(:carb_container) do |as: nil, init: auto_init|
        as ||= convert.call(self.name.to_s)
        as   = as.to_sym
        kontainer.register(as, -> { self.new })     if init
        kontainer.register(as, -> { self })     unless init
      end
      send(:protected, :carb_container)
    end
  end
end
