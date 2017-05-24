require "spec_helper"
require "carb/container/class_name_to_method_name"

describe Carb::Container::ClassNameToMethodName do
  describe "#call" do
    it "converts to underscore the text and replaces / with _" do
      converter = Carb::Container::ClassNameToMethodName.new

      converted = converter.call("Foo::HTML::Whatever")

      expect(converted).to eq "foo_html_whatever"
    end
  end
end
