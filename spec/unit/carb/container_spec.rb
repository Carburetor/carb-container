require "spec_helper"

describe Carb::Container do
  it "has a version number" do
    expect(Carb::Container::VERSION).to be_a String
  end
end
