require "carb"
require "carb/container/registerer"
require "forwardable"

module Carb::Container
  # Provides a method hook in all classes to register them as injectable
  class RegistrationGlue
    def call(container, target: Class, registerer: Registerer)
      target.send(:include, registerer.new(container))
    end

    class << self
      extend Forwardable

      def_delegators :new, :call
    end
  end
end
