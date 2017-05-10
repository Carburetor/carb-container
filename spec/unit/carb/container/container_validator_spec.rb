require "spec_helper"
require "carb/container/container_validator"
require "carb/container/registry_container"

describe Carb::Container::ContainerValidator do
  describe "#call" do
    it "is false when object isn't a container" do
      container = Object.new
      validator = Carb::Container::ContainerValidator.new

      expect(validator.(container)).to be false
    end

    it "is true when object behaves like a container" do
      container = {}
      validator = Carb::Container::ContainerValidator.new

      expect(validator.(container)).to be true
    end

    it "is true when object is a container" do
      container = Carb::Container::RegistryContainer.new
      validator = Carb::Container::ContainerValidator.new

      expect(validator.(container)).to be true
    end
  end
end
