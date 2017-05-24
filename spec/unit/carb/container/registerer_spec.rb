require "spec_helper"
require "carb/container/registerer"

describe Carb::Container::Registerer do
  before do
    @container = spy("Container", register: nil)
  end

  describe "#included" do
    it "creates .carb_container method on the including class" do
      registerer = Carb::Container::Registerer.new(@container)

      klass = Class.new { include registerer }

      expect(klass).to respond_to(:carb_container)
    end

    it "calls register when .carb_container is run" do
      registerer = Carb::Container::Registerer.new(@container)

      Class.new do
        include registerer
        carb_container as: :foo
      end

      expect(@container).to have_received(:register).with(:foo, kind_of(Proc))
    end
  end
end
