require "carb"
require "carb/registerer"

module Carb::Container
  # Provides a method hook in all classes to register them as injectable
  class RegistrationGlue
    def call(container, target: Class, registerer: Registerer)
      target.send(:include, registerer.new(container))
    end

    def self.call(container, target: Class, registerer: Registerer)
      new.call(container, target: target)
    end
  end
end
