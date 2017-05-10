require "spec_helper"
require "carb/container/error_container"
require "carb/container/dependency_missing_error"

describe Carb::Container::ErrorContainer do
  describe "#[]" do
    it "raises every time a dependency is resolved" do
      container = Carb::Container::ErrorContainer.new
      error     = Carb::Container::DependencyMissingError

      expect { container[:foo] }.to raise_error error
    end
  end

  describe "#has_key?" do
    it "is always false" do
      container = Carb::Container::ErrorContainer.new

      expect(container.has_key?(:foo)).to be false
    end
  end
end
