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
      # Required for scope purposes
      cont = container
      klass.define_singleton_method(:carb_container) do |as: nil|
        as ||= maybe_snake_case(self.name.to_s)
        as   = as.to_sym
        cont.register(as, -> { self })
      end
    end

    private

    def maybe_snake_case(text)
      return text unless maybe_require_activesupport
      return text unless defined?(::ActiveSupport)
      return text.underscore if text.respond_to?(:underscore)

      ActiveSupport::Inflector.underscore(text)
    end

    def maybe_require_activesupport
      require "active_support/inflector/methods"
      true
    rescue
      false
    end
  end
end
