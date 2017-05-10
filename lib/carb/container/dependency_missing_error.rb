require "carb"

module Carb::Container
  # Error when trying to fetch a dependency which doesn't exist
  class DependencyMissingError < StandardError
    MESSAGE = "Dependency \"%s\" doesn't exist " \
              "in this container".freeze

    attr_reader :name

    def initialize(name)
      @name = name
    end
  end
end
