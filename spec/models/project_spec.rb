require 'spec_helper'

describe Project do
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:github_url) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:main_language) }
  it { should validate_uniqueness_of(:github_url).with_message('Project has already been suggested.') }
  it { should ensure_length_of(:description).is_at_least(20).is_at_most(200) }

  context "validations" do
    let(:project) { FactoryGirl.build(:project) }

    it "should not pass on wrong programming language" do
      project.main_language = "English"
      project.valid?.should_not be_true
      project.errors[:main_language].include?('must be a programming language').should be_true
    end

    it "should pass on correct programming language" do
      project.main_language = "Ruby"
      project.valid?.should be_true
    end

    it "should pass on github urls with periods" do
      project.github_url = "https://github.com/kangax/fabric.js"
      project.valid?.should be_true
    end
  end

  context "#scopes" do
    let!(:ruby_project) { FactoryGirl.create(:project, main_language: "Ruby") }

    before do
      ["Erlang", "JavaScript"].each { |lan| FactoryGirl.create(:project, main_language: lan)  }
    end

    it "by_language" do
      Project.by_language("ruby").should eq([ruby_project])
    end
  end
end
