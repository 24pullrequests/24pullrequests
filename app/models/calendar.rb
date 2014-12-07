class Calendar
  include Enumerable

  attr_reader :giftable_dates, :gifts

  def initialize(giftable_dates, gifts)
    @giftable_dates = giftable_dates
    @gifts          = gifts
  end

  def each
    giftable_dates.each do |date|
      gift = gifts.find { |gift| gift.date == date }

      yield(date, gift)
    end
  end

  alias_method :each_day, :each

  def start_padding
    giftable_dates.first.wday - 1
  end
end
