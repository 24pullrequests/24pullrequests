require 'spec_helper'

describe GiftForm do
  context '.pull_requests_for_select' do
    it "formats pull requests for select boxes" do
      gifts = [mock('pr', :to_param => '1', :title => 'Foo', :repo_name => 'Bar', :gifted_state => :gifted)]
      pull_requests = stub(:includes => gifts, :sort => gifts)
      form = GiftForm.new(:gift => mock('gift'),
                          :pull_requests => pull_requests)

      form.pull_requests_for_select.should == [['Gifted: Bar - Foo', '1']]
    end
  end

  it "formats dates for select boxes" do
    dates = [Date.new(2012, 12, 1), Date.new(2012,12,2)]

    form = GiftForm.new(:gift => mock('gift'),
                        :pull_requests => mock('reqs'),
                        :giftable_dates => dates)

    form.giftable_dates.should == [['December 1st','2012-12-01'],
                                   ['December 2nd','2012-12-02']]
  end

  it "assumes that you don't want a date select if giftable_dates is nil" do
    form = GiftForm.new(:gift => mock('gift'),
                        :pull_requests => mock('reqs'))

    form.show_date_select?.should be_false
  end
end
