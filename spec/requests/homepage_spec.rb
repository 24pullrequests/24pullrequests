require 'spec_helper'

describe "Homepage", js: true do
  describe "GET /" do
    it "Loads" do
      visit '/'
    end
  end
end
