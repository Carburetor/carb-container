require "carb"
require "carb/container/base"
require "carb/container/dependency_missing_error"

module Carb::Container
  # Container which holds no dependency and will raise every time
  # one is being fetched
  class ErrorContainer
    include ::Carb::Container::Base

    # This method will always raise an error
    # @param name [Object] dependency name
    # @raise [::Carb::Container::DependencyMissingError] raised
    #   whenever a dependency is being fetched from this container
    def [](name)
      error_class = ::Carb::Container::DependencyMissingError
      raise error_class.new(name), format(error_class::MESSAGE, name.to_s)
    end

    # @param name [Object] dependency name
    # @return [false]
    def has_key?(name)
      false
    end
  end
end
