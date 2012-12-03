require 'spec_helper'

describe Project do
  it { should allow_mass_assignment_of(:description) }
  it { should allow_mass_assignment_of(:github_url) }
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:main_language) }

  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:github_url) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:main_language) }
  it { should validate_uniqueness_of(:github_url).with_message('Project has already been suggested.') }
  it { should ensure_length_of(:description).is_at_least(20).is_at_most(200) }

  it "Validation should not pass on wrong programming language" do
    project = FactoryGirl.build(:project)
    project.main_language = "English"
    project.valid?.should_not be_true
    project.errors[:main_language].include?('must be a programming language').should be_true
  end

  it "Validation should pass on correct programming language" do
    project = FactoryGirl.build(:project)
    project.main_language = "Ruby"
    project.valid?.should be_true
  end
  
  it "Validation should pass on github urls with periods" do
    project = FactoryGirl.build(:project)
    project.github_url = "https://github.com/kangax/fabric.js"
    project.valid?.should be_true
  end
end
