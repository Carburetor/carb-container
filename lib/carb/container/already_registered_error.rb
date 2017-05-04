require "carb"

module Carb::Container
  # Error when a dependency with same name already exists
  class AlreadyRegisteredError < StandardError
    MESSAGE = "Dependency %s already exists, registered at:\n%s".freeze

    attr_reader :name

    def initialize(name)
      @name = name
    end
  end
end
