require "carb"

module Carb::Container
  # Checks if object is a valid container
  class ContainerValidator
    # @param container [Object]
    # @return [Boolean] true if object is a container, false otherwise
    def call(container)
      is_container   = container.respond_to?(:[])
      is_container &&= container.respond_to?(:has_key?)

      is_container
    end

    # @param container [Object]
    # @return [Boolean] true if object is a container, false otherwise
    def self.call(container)
      new.call(container)
    end
  end
end
