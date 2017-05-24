require "carb"
require "carb/container/class_name_to_method_name"

module Carb::Container
  # Provides a class method to register classes globally
  class Registerer < Module
    private

    attr_reader :container
    attr_reader :converter

    # @param container [#register] object which will be used to register
    #   dependencies as {::Proc}
    def initialize(container, converter: ClassNameToMethodName.new)
      @container = container
      @converter = converter
    end

    def included(klass)
      # Required for scope purposes
      kontainer = container
      convert   = converter

      klass.define_singleton_method(:carb_container) do |as: nil|
        as ||= convert.call(self.name.to_s)
        as   = as.to_sym
        kontainer.register(as, -> { self })
      end
    end
  end
end
