require 'spec_helper'

describe "Users" do
  describe "GET /" do
    it "returns a list of users" do
      get users_path
      assigns(:users).should_not be_nil
      response.status.should be(200)
    end
  end
end
