require 'spec_helper'

describe Gift do
  fixtures :users
  fixtures :pull_requests

  it "there can only be one per user per day" do
    user = User.find_by_nickname('clowder')
    Gift.create(:user => user,
                :pull_request => user.pull_requests.first,
                :date => Date.parse("2012-12-1"))

    second_gift = Gift.new(:user => user,
                           :pull_request => user.pull_requests.first,
                           :date => Date.parse("2012-12-1"))
    second_gift.should_not be_valid
    second_gift.errors[:date].should == ["you only need one gift per day. Save it for tomorrow!"]
  end

  it "helps rails by returning its date for #to_param" do
    Gift.new(:date => Date.parse("2012-12-1")).to_param.should == '2012-12-01'
  end

  it "allows you to find a gift by user and date" do
    user = User.find_by_nickname('clowder')
    date = Date.parse("2012-12-1")
    gift = Gift.create(:user => user,
                       :pull_request => user.pull_requests.first,
                       :date => date)


    Gift.find(user, date).should == gift
  end

  it "has a default date when created" do
    Gift.default_date = ->{ Date.parse('2012-12-1') }
    Gift.new.date.should == Date.parse('2012-12-1')
  end
end
