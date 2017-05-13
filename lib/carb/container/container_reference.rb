require "carb"
require "carb/container/container_hook_already_defined_error"
require "carb/container/reference_var"

module Carb::Container
  class ContainerReference < Module
    AlreadyDefinedReferenceError = Class.new(StandardError)
    ReferenceVar = :@__carb_container__

    private

    attr_reader :container

    public

    def initialize(container)
      @container = container
    end

    def included(klass)
      unless klass.instance_variable_get(ReferenceVar).nil?
      end

      klass.instance_variable_set(ReferenceVar, container)
      klass.extend()
    end

    private

    def ensure_reference_present!
      reference = klass.instance_variable_get(ReferenceVar)
      return if reference.nil?

      error_class = ContainerHookAlreadyDefinedError
      raise error_class, "Container reference already exists"
    end
  end
end
