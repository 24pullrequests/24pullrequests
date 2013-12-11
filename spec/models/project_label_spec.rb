require 'spec_helper'

describe ProjectLabel do
  subject { ProjectLabel.new }

  context "validations" do
    it "must have a label" do
      should validate_presence_of(:label_id)
    end

    it "must only have a label allocated to a project once" do
      should validate_uniqueness_of(:label_id).scoped_to(:project_id)
    end
  end
end
