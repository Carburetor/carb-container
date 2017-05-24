require "carb"
require "carb/container/class_name_to_method_name"

module Carb::Container
  # Provides a class method to register classes globally
  class Registerer < Module
    private

    attr_reader :container

    def initialize(container)
      @container = container
    end

    def included(klass)
      # Required for scope purposes
      cont       = container
      snake_case = ClassNameToMethodName.new

      klass.define_singleton_method(:carb_container) do |as: nil|
        as ||= snake_case.call(self.name.to_s)
        as   = as.to_sym
        cont.register(as, -> { self })
      end
    end
  end
end
