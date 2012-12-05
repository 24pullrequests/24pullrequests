class GiftForm
  attr_reader :gift

  def initialize(args={})
    @gift = args.fetch(:gift)
    @giftable_dates = args.fetch(:giftable_dates, [])
    @pull_requests = args.fetch(:pull_requests)
    @gift.date = args.fetch(:date) if args.fetch(:date, nil)
  end

  def pull_requests
    @pull_requests.map { |pr| [pr.title, pr.to_param] }
  end

  def giftable_dates
    @giftable_dates.map { |date|
      ["#{ date.strftime('%B') } #{ date.mday.ordinalize }", date.to_s]
    }
  end

  def show_date_select?
    !@giftable_dates.empty?
  end
end
