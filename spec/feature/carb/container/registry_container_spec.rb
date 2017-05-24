require "spec_helper"
require "carb-container"
require "carb/container/registry_container"
require "carb/container/registration_glue"

describe Carb::Container::RegistryContainer, type: :feature do
  before do
    @container = Carb::Container::RegistryContainer.new
    @baseclass = Class.new
    Carb::Container::RegistrationGlue.call(@container, target: @baseclass)
  end

  it "registers class inside container under given alias name" do
    klass = Class.new(@baseclass)
    stub_const("Foo", klass)

    klass.instance_eval { carb_container as: :bar }

    expect(@container[:bar]).to eq klass
  end

  it "registers class inside container with guessed name" do
    klass = Class.new(@baseclass)
    stub_const("Foo::Bar", klass)

    klass.instance_eval { carb_container }

    expect(@container[:foo_bar]).to eq klass
  end
end
