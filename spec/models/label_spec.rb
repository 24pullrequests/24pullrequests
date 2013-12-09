require 'spec_helper'

describe Label do
  subject { Label.new }

  context "validations" do
    it "must have a name" do
      should have(1).error_on(:name)
    end

    it "the name must be unique" do
      Label.create name: "documentation"
      label = Label.create name: "documentation"

      label.should have(1).error_on(:name)
    end
  end
end
