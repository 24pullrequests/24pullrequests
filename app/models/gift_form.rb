class GiftForm
  attr_reader :gift

  def initialize(args = {})
    @gift = args.fetch(:gift)
    @giftable_dates = args.fetch(:giftable_dates, [])
    @contributions = args.fetch(:contributions)
    @gift.date = args.fetch(:date) if args.fetch(:date, nil)
  end

  def contributions_for_select
    @contributions
      .select { |pr| pr.created_at.year == Time.now.year }
      .sort { |pr1, pr2| pr2.gifted_state <=> pr1.gifted_state }
      .map do |pr|
        ["#{pr.gifted_state.to_s.humanize}: #{pr.repo_name} - #{pr.title}", pr.to_param]
      end
  end

  def giftable_dates
    @giftable_dates.map do |date|
      [Gift.format_gift_date(date), date.to_s]
    end
  end

  def show_date_select?
    !@giftable_dates.empty?
  end
end
