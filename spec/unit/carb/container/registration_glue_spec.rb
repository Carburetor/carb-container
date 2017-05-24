require "spec_helper"
require "carb/container/registration_glue"
require "carb/container/registerer"

describe Carb::Container::RegistrationGlue do
  Glue = Carb::Container::RegistrationGlue

  before do
    @module     = instance_double(Carb::Container::Registerer)
    @target     = class_spy(Class, include: nil)
    @registerer = class_double(Carb::Container::Registerer, new: @module)
  end

  describe ".call" do
    it "delegates without raising" do
      Glue.call({}, target: @target, registerer: @registerer)

      expect(@target).to have_received(:include).with(@module)
    end
  end

  describe "#call" do
    it "runs #include on @target with @module as argument" do
      glue = Glue.new

      glue.call({}, target: @target, registerer: @registerer)

      expect(@target).to have_received(:include).with(@module)
    end
  end
end
