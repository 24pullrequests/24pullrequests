require File.expand_path('../../../app/models/calendar', __FILE__)
require 'date'

describe Calendar, type: :model do
  it 'returns an enumerator for the giftable_dates' do
    giftable_dates = 1.upto(24).map { |day| Date.new(Tfpullrequests::Application.current_year, 12, day) }

    sorted_gifts = Calendar.new(giftable_dates, [])
    expect(sorted_gifts.count).to eq(24)
  end

  it 'yields the right gift for the right day' do
    the_first  = double('gift', date: Date.parse("#{Tfpullrequests::Application.current_year}-12-1"))
    the_fourth = double('gift', date: Date.parse("#{Tfpullrequests::Application.current_year}-12-4"))
    the_end    = double('gift', date: Date.parse("#{Tfpullrequests::Application.current_year}-12-24"))

    gifts          = [the_end, the_fourth, the_first]
    giftable_dates = 1.upto(24).map { |day| Date.new(Tfpullrequests::Application.current_year, 12, day) }

    sorted_gifts = Calendar.new(giftable_dates, gifts)
    sorted_gifts = sorted_gifts.map { |_day, gift| gift }

    expect(sorted_gifts[0]).to eq(the_first)
    expect(sorted_gifts[1]).to be_nil
    expect(sorted_gifts[2]).to be_nil
    expect(sorted_gifts[3]).to eq(the_fourth)
    expect(sorted_gifts[23]).to eq(the_end)
  end

  it 'knows the week day padding for the first date in the sequence' do
    giftable_dates = [Date.new(Tfpullrequests::Application.current_year, 12, 1)]

    calendar = Calendar.new(giftable_dates, [])
    expect(calendar.start_padding).to eq(-1)
  end
end
