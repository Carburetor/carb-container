require "carb"
require "carb/container/container_hook_missing_error"

module Carb::Container
  module Registrable
    def carb_container(as: nil)
      container = instance_variable_get()
    end
  end
end
