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
    before do
      ["Erlang", "JavaScript"].each { |lan| FactoryGirl.create(:project, main_language: lan)  }
      2.times { FactoryGirl.create(:project, main_language: "Haskell", inactive: true) }
    end

    it "by_language" do
      project = FactoryGirl.create(:project, main_language: "Ruby")

      Project.by_language("ruby").should eq([project])
    end

    it "active" do
      Project.active.count.should eq(2)
    end
  end

  context "#finders" do
    it "#find_by_github_repo" do
      project = create :project, github_url: "http://github.com/elfs/presents"

      Project.find_by_github_repo("elfs/presents").should eq(project)
    end
  end

  context "#deactive" do
    let(:project) { FactoryGirl.create(:project) }

    it "sets the project to inactive" do
      project.deactivate!

      project.reload.inactive.should be_true
    end
  end

  context "#issues" do
    let(:project) { FactoryGirl.create(:project) }

    it "retrieves github issues that have been active in the last 6 months" do
      date = (Time.now-6.months).utc.iso8601
      github_client = double(:github_client)

      github_client.should_receive(:issues).with(project.github_repository, status: 'open', since: date)

      project.issues(github_client)
    end

  end
end
