require 'spec_helper'

describe ProjectLabel do
  subject { ProjectLabel.new }

  context "validations" do
    it "must have a label" do
      should have(1).error_on(:label)
    end

  end
end
