require "spec_helper"

RSpec.describe Carb::Container do
  it "has a version number" do
    expect(Carb::Container::VERSION).not_to be nil
  end
end
