require 'rails_helper'

describe Project, :type => :model do
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:github_url) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:main_language) }
  it { is_expected.to validate_uniqueness_of(:github_url).with_message('Project has already been suggested.') }
  it { is_expected.to ensure_length_of(:description).is_at_least(20).is_at_most(200) }

  context "validations" do
    let(:project) { FactoryGirl.build(:project) }

    it "should not pass on wrong programming language" do
      project.main_language = "English"
      expect(project.valid?).not_to be true
      expect(project.errors[:main_language].include?('must be a programming language')).to be true
    end

    it "should pass on correct programming language" do
      project.main_language = "Ruby"
      expect(project.valid?).to be true
    end

    it "should pass on github urls with periods" do
      project.github_url = "https://github.com/kangax/fabric.js"
      expect(project.valid?).to be true
    end
  end

  context "#scopes" do
    before do
      ["Erlang", "JavaScript"].each { |lan| FactoryGirl.create(:project, main_language: lan)  }
      2.times { FactoryGirl.create(:project, main_language: "Haskell", inactive: true) }
    end

    it "by_language" do
      project = FactoryGirl.create(:project, main_language: "Ruby")

      expect(Project.by_language("ruby")).to eq([project])
    end

    it "active" do
      expect(Project.active.count).to eq(2)
    end
  end

  context "#finders" do
    it "#find_by_github_repo" do
      project = create :project, github_url: "http://github.com/elfs/presents"

      expect(Project.find_by_github_repo("elfs/presents")).to eq(project)
    end
  end

  context "#deactive" do
    let(:project) { FactoryGirl.create(:project) }

    it "sets the project to inactive" do
      project.deactivate!

      expect(project.reload.inactive).to be true
    end
  end

  context "#issues" do
    let(:project) { FactoryGirl.create(:project) }

    it "retrieves github issues that have been active in the last 6 months" do
      date = (Time.zone.now - 6.months).utc.iso8601
      client = double(:github_client)
      expect(GithubClient).to receive(:new).with("username", "token").and_return(client)
      expect(client).to receive(:issues)

      project.issues("username", "token")
    end

  end
end
