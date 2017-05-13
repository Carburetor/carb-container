require "carb"

module Carb::Container
  # Provides a class method to register classes globally
  class Registerer < Module
    private

    attr_reader :container

    def initialize(container)
      @container = container
    end

    def included(klass)
      # TODO: Test registerer and registration glue
      # Required for scope purposes
      cont = container
      klass.send(:define_method, :carb_container) do |as: nil|
        as ||= maybe_snake_case(self.name.to_s)
        as   = as.to_sym
        cont.register(as, -> { self })
      end
    end

    private

    def maybe_snake_case(text)
      return text unless defined?(::ActiveSupport)
      return text.underscore if text.respond_to?(:underscore)

      require "active_support/inflector/methods"
      ActiveSupport::Inflector.underscore(text)
    end
  end
end
