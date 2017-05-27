require "spec_helper"
require "carb/container/registerer"
require "carb/container/registry_container"

describe Carb::Container::Registerer do
  before do
    @container = spy("Container", register: nil)
  end

  it "creates .carb_container method on the extending class" do
    registerer = Carb::Container::Registerer.new(@container)

    klass = Class.new { extend registerer }

    expect(klass.protected_methods).to include :carb_container
  end

  describe ".carb_container" do
    it "registers when run with specified alias and Proc" do
      registerer = Carb::Container::Registerer.new(@container)

      Class.new do
        extend registerer
        carb_container as: :foo
      end

      expect(@container).to have_received(:register).with(:foo, kind_of(Proc))
    end

    it "registers class where is invoked" do
      container  = Carb::Container::RegistryContainer.new
      registerer = Carb::Container::Registerer.new(container)

      klass = Class.new do
        extend registerer
        carb_container as: :foo
      end

      expect(container[:foo]).to eq klass
    end

    it "guesses class name when registering" do
      container  = Carb::Container::RegistryContainer.new
      registerer = Carb::Container::Registerer.new(container)
      klass      = Class.new { extend registerer }
      stub_const("Foo::MyClass", klass)

      Foo::MyClass.send(:carb_container)

      expect(container[:foo_my_class]).to eq klass
    end
  end
end
