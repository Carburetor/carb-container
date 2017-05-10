require "carb"

module Carb::Container
  # Provides a method hook in all classes to register them as injectable
  class Registrable
    def call(container)
      # TODO: Inject stuff in Class to provide a `carb_container as: :name`
    end

    def self.call(container)
      new.call(container, name: name)
    end
  end
end
