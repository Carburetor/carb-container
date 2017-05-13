require "carb"

module Carb::Container
  # Interface for container definition
  module Base
    def [](name)
      raise NotImplementedError, "#[] not implemented"
    end

    def has_key?(name)
      raise NotImplementedError, "#has_key? not implemented"
    end
  end
end
