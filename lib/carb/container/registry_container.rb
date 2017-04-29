require "carb"

module Carb::Container
  # Simple {Hash} based container for dependency resolution based on name, with
  # further registration capabilities
  class RegistryContainer
    private

    attr_reader :dependencies

    public

    # @param dependencies [Hash{Object => Proc}] dependency name with proc
    #   as value, which will be `call`ed to extract the dependency object
    def initialize(dependencies)
      @dependencies = {}
      dependencies.each { |name, dep| register(name, dep) }
    end

    # @param name [Object] name used to fetch back the dependency
    # @param dependency [Proc] dependency to be stored, must be wrapped within
    #   a lambda
    # @raise [TypeError] raised if dependency is not a {Proc}
    # @raise [AlreadyRegisteredError] raise when a dependency with same name
    #   already exists
    # @return [Proc] the registered dependency
    def register(name, dependency)
      ensure_dependency_type!(dependency)
      ensure_dependency_uniqueness!(name)

      dependencies[name] = dependency
    end

    # Gets a dependency
    # @param name [Object] dependency name with which it was registered
    # @return [nil, Object] nil if dependency is missing, otherwise the
    #   dependency, unwrapped from proc
    def [](name)
      dependencies[name].()
    end

    # Checks if the dependency exists within the container
    # @param name [Object] dependency name with which it was registered
    # @return [Boolean] true if the dependency exists within the container,
    #   false otherwise
    def has_key?(name)
      dependencies.has_key?(name)
    end

    private

    def ensure_dependency_type!(dependency)
      unless dependency.respond_to?(:call)
        raise TypeError, "dependency must be a Proc"
      end
    end

    def ensure_dependency_uniqueness!(name)
      if dependencies.has_key?(name)
        error_class = AlreadyRegisteredError
        raise error_class.new(name), format(error_class::MESSAGE, name.to_s)
      end
    end
  end
end
