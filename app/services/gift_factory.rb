class GiftFactory
  attr_reader :gift

  def self.create!(user, factory, attrs={})
    gift_factory = GiftFactory.new(user, factory)
    return gift_factory.create_from_attrs(attrs)
  end

  def initialize(user, factory)
    @user = user
    @factory = factory
  end

  def create_from_attrs(attrs={})
    gift = @factory.call(attrs)
    gift.date ||= closest_free_gift_date
    gift.user = @user
    gift
  end

  private

  def closest_free_gift_date
    previous_gift.present? ? previous_gift.date + 1.day : PullRequest::EARLIEST_PULL_DATE
  end

  def previous_gift
    @previous_gift ||= @user.gifts.last
  end
end
