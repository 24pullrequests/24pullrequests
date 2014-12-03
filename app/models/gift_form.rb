class GiftForm
  attr_reader :gift

  def initialize(args={})
    @gift = args.fetch(:gift)
    @giftable_dates = args.fetch(:giftable_dates, [])
    @pull_requests = args.fetch(:pull_requests)
    @gift.date = args.fetch(:date) if args.fetch(:date, nil)
  end

  def pull_requests_for_select
    @pull_requests
      .select { |pr| pr.created_at.year == Time.now.year }
      .sort{ |pr1, pr2| pr2.gifted_state <=> pr1.gifted_state }
      .map{ |pr|
        ["#{pr.gifted_state.to_s.humanize}: #{pr.repo_name} - #{pr.title}", pr.to_param]
      }
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
