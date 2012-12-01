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
  it { should validate_uniqueness_of(:github_url).with_message('already been submitted') }
  it { should ensure_length_of(:description).is_at_least(20).is_at_most(200) }

  it "validates the github url" do
    subject.github_url = 'not_a_repo'
    subject.valid?
    subject.errors[:github_url].should_not be_empty
  end

  it "normalizes the github url before saving" do
    project = Project.new(:github_url => 'user/repo')
    project.normalize_github_url
    project.github_url.should == 'https://github.com/user/repo'
  end
end
