require "carb"

module Carb::Container
  class ClassNameToMethodName
    def call(text)
      snaked = maybe_snake_case(text)
      snaked = snaked.gsub("/", "_")
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
