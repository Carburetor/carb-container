require "spec_helper"
require "carb/container/registry_container"
require "carb/container/already_registered_error"

RSpec.describe Carb::Container::RegistryContainer do
  it "can be initialized with a hashmap of dependencies" do
    deps      = { foo: -> { 123 } }
    container = Carb::Container::RegistryContainer.new(deps)

    expect(container[:foo]).to eq 123
  end

  it "raises when initialized with non-procs values in hashmap" do
    deps = { foo: 123 }
    init = -> { Carb::Container::RegistryContainer.new(deps) }

    expect { init.() }.to raise_error TypeError
  end

  describe "#register" do
    it "stores passed dependency under given name" do
      container = Carb::Container::RegistryContainer.new

      container.register(:foo, -> { 123 })

      expect(container[:foo]).to eq 123
    end

    it "returns self" do
      container = Carb::Container::RegistryContainer.new

      self_container = container.register(:foo, -> { 123 })

      expect(self_container).to be container
    end

    it "raises when dependency is not a proc" do
      container = Carb::Container::RegistryContainer.new

      register = -> { container.register(:foo, 123) }

      expect { register.() }.to raise_error TypeError
    end

    it "raises when dependency is already registered" do
      container = Carb::Container::RegistryContainer.new
      container.register(:foo, -> { 123 })

      register = -> { container.register(:foo, -> { 123 }) }

      expect { register.() }.to raise_error(
        Carb::Container::AlreadyRegisteredError
      )
    end
  end

  describe "#has_key?" do
    it "is false when no dependency registered under given name" do
      container = Carb::Container::RegistryContainer.new

      expect(container.has_key?(:foo)).to be false
    end

    it "is true when a dependency is registered under given name" do
      container = Carb::Container::RegistryContainer.new
      container.register(:foo, -> { 123 })


      expect(container.has_key?(:foo)).to be true
    end
  end
end
