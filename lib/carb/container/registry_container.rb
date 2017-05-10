require "carb"
require "carb/container/base"
require "carb/container/already_registered_error"
require "carb/container/dependency_missing_error"

module Carb::Container
  # Simple {Hash} based container for dependency resolution based on name, with
  # further registration capabilities
  class RegistryContainer
    include ::Carb::Container::Base

    Record = Struct.new(:dependency, :registerer)

    private

    attr_reader :dependencies

    public

    # @param dependencies [Hash{Object => Proc}] dependency name with proc
    #   as value, which will be `call`ed to extract the dependency object
    def initialize(dependencies = {})
      @dependencies = {}
      dependencies.each do |name, dep|
        register_with_caller(name, dep, caller_locations[0])
      end
    end

    # @param name [Object] name used to fetch back the dependency
    # @param dependency [Proc] dependency to be stored, must be wrapped within
    #   a lambda
    # @raise [TypeError] raised if dependency is not a {Proc}
    # @raise [AlreadyRegisteredError] raise when a dependency with same name
    #   already exists
    # @return [RegistryContainer] self (for chaining purposes)
    def register(name, dependency)
      register_with_caller(name, dependency, caller_locations[0])
      self
    end

    # Gets a dependency
    # @param name [Object] dependency name with which it was registered
    # @return [nil, Object] nil if dependency is missing, otherwise the
    #   dependency, unwrapped from proc
    def [](name)
      ensure_dependency_present!(name)

      dependencies[name].dependency.()
    end

    # Checks if the dependency exists within the container
    # @param name [Object] dependency name with which it was registered
    # @return [Boolean] true if the dependency exists within the container,
    #   false otherwise
    def has_key?(name)
      dependencies.has_key?(name)
    end

    private

    def register_with_caller(name, dependency, registerer)
      ensure_dependency_type!(dependency)
      ensure_dependency_uniqueness!(name)

      dependencies[name] = Record.new(dependency, registerer)
    end

    def ensure_dependency_present!(name)
      return if has_key?(name)

      raise DependencyMissingError.new(name), missing(name)
    end

    def ensure_dependency_type!(dependency)
      return if dependency.respond_to?(:call)

      raise TypeError, "dependency must be a Proc"
    end

    def ensure_dependency_uniqueness!(name)
      return unless dependencies.has_key?(name)

      record = dependencies.fetch(name)
      raise AlreadyRegisteredError.new(name), registered(name, record)
    end

    def registered(name, record)
      registerer = record.registerer
      format(AlreadyRegisteredError::MESSAGE, name.to_s, registerer.to_s)
    end

    def missing(name)
      format(DependencyMissingError::MESSAGE, name.to_s)
    end
  end
end
