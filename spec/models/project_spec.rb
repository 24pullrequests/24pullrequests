require 'spec_helper'

describe Project do
  it "disallows projects with relative urls to be created" do
    project = Project.new \
      description: 'test test test test test',
      github_url: 'github.com/test/test',
      name: 'test',
      main_language: 'Ruby'

    project.should_not be_valid
    project.errors.full_messages.should include("Github url must be fully qualified (beginning with http://)")
    project.errors.full_messages.count.should == 1
  end
end
