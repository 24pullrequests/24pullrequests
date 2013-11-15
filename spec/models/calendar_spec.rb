require File.expand_path('../../../app/models/calendar', __FILE__)

describe Calendar do
  it "returns an enmerator for the giftable_dates" do
    giftable_dates = 1.upto(24).map { |day| Date.new(2013,12,day) }

    sorted_gifts = Calendar.new(giftable_dates, [])
    sorted_gifts.count.should == 24
  end

  it "yields the right gift for the right day" do
    the_first  = double('gift', :date => Date.parse('2013-12-1'))
    the_fourth = double('gift', :date => Date.parse('2013-12-4'))
    the_end    = double('gift', :date => Date.parse('2013-12-24'))

    gifts          = [the_end, the_fourth, the_first]
    giftable_dates = 1.upto(24).map { |day| Date.new(2013,12,day) }

    sorted_gifts = Calendar.new(giftable_dates, gifts)
    sorted_gifts = sorted_gifts.map { |day, gift| gift }

    sorted_gifts[0].should  == the_first
    sorted_gifts[1].should be_nil
    sorted_gifts[2].should be_nil
    sorted_gifts[3].should  == the_fourth
    sorted_gifts[23].should == the_end
  end

  it "knows the week day padding for the first date in the sequence" do
    giftable_dates = [Date.new(2013,12,1)]

    calendar = Calendar.new(giftable_dates, [])
    calendar.start_padding.should == -1
  end
end
