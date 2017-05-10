require "carb"
require "carb/container/base"
require "carb/container/dependency_missing_error"
require "carb/container/container_validator"

module Carb::Container
  # Container which requests dependency in sequence to a list of containers
  # otherwise and if none returns, it raises
  class DelegateContainer
    include ::Carb::Container::Base

    private

    attr_reader :containers
    attr_reader :dependencies

    public

    # @param containers [Array<#[], #has_key?>] Must have at least one
    #   container
    # @raise [ArgumentError] unless at least one container is supplied
    def initialize(containers, **dependencies)
      @containers   = containers
      @dependencies = dependencies
      dependencies[:container_validator] ||= ContainerValidator.new

      ensure_at_least_one_container!(containers)
      ensure_all_are_containers!(containers)
    end

    # @param name [Object] dependency name
    # @return [Object] dependency for given name if present in any container
    #   (only the first in sequence is returned), otherwise raises
    # @raise [DependencyMissingError]
    def [](name)
      containers.each do |container|
        return container[name] if container.has_key?(name)
      end

      error_class = ::Carb::Container::DependencyMissingError
      raise error_class.new(name), format(error_class::MESSAGE, name.to_s)
    end

    # @param name [Object] dependency name
    # @return [Boolean] true if dependency is present in any container, false
    #   otherwise
    def has_key?(name)
      containers.any? { |container| container.has_key?(name) }
    end

    private

    def ensure_at_least_one_container!(containers)
      return if containers.size > 0

      raise ArgumentError, "At least one container is required"
    end

    def ensure_object_is_container!(container, index)
      return if container_validator.(container)

      raise TypeError, "Container at index #{index} is not valid"
    end

    def ensure_all_are_containers!(containers)
      containers.each_with_index do |container, index|
        ensure_object_is_container!(container, index)
      end
    end

    def container_validator
      dependencies[:container_validator]
    end
  end
end
