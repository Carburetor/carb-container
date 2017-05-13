require "carb"

module Carb::Container
  # Provides a method hook in all classes to register them as injectable
  class HookRegistrable
    def call(container, target: Class)
      # TODO: Inject stuff in Class to provide a `carb_container as: :name`

    end

    def self.call(container, target: Class)
      new.call(container, target: target)
    end
  end
end
