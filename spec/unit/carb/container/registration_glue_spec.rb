require "spec_helper"
require "carb/container/registration_glue"
require "carb/container/registerer"

describe Carb::Container::RegistrationGlue do
  Registerer = Carb::Container::Registerer

  before do
    @glue       = Carb::Container::RegistrationGlue.new
    @module     = instance_double(Registerer)
    @target     = class_spy(Module, :<= => Module)
    @registerer = class_double(Registerer, new: @module)
    allow(@glue).to receive(:perform_include).and_return(nil)
  end

  describe "#call" do
    it "passes :init to registerer class when initializing it" do
      map = {}
      allow(@registerer).to receive(:new).and_return(@module)

      @glue.call(map, init: true, target: @target, registerer: @registerer)

      expect(@registerer).to have_received(:new).
        with(map, init: true, converter: anything)
    end

    it "runs #include on @target with @module as argument" do
      @glue.call({}, target: @target, registerer: @registerer)

      expect(@glue).to have_received(:perform_include).
        with(@target, :include, @module)
    end

    it "runs #include on @target if inherits from Module" do
      other_module = Class.new(Module)
      allow(other_module).to receive(:include).and_return(nil)

      @glue.call({}, target: other_module, registerer: @registerer)

      expect(@glue).to have_received(:perform_include).
        with(other_module, :include, @module)
    end

    it "runs #extend on @target if doesn't inherit from Module" do
      other_module = Class.new
      allow(other_module).to receive(:include).and_return(nil)

      @glue.call({}, target: other_module, registerer: @registerer)

      expect(@glue).to have_received(:perform_include).
        with(other_module, :extend, @module)
    end
  end
end
