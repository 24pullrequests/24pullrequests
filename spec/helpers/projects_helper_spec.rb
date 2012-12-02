require 'spec_helper'

describe ProjectsHelper do
  it "should format given url" do
    format_url("github.com/grobertson/s").should == "https://github.com/grobertson/s"
    format_url("https://github.com/orendon/contrib-hub").should == "https://github.com/orendon/contrib-hub"
  end
end