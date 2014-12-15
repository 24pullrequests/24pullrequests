class Gift < ActiveRecord::Base
  class << self
    attr_writer :default_date
  end

  attr_accessor :tweet

  belongs_to :user
  belongs_to :pull_request

  validates :user, presence: true
  validates :pull_request, presence: true
  validates :date, presence:   true,
                   uniqueness: { scope:   :user_id,
                                 message: 'you only need one gift per day. Save it for tomorrow!' },
                   inclusion:  { in:      proc { Gift.giftable_dates },
                                 message: 'your gift should be for the month of December.' }

  delegate :title, :issue_url, to: :pull_request, prefix: true

  scope :year, -> (year) { where('EXTRACT(year FROM "created_at") = ?', year) }

  after_initialize do
    self.date ||= Gift.default_date
  end

  def self.find(user_id, date)
    where(user_id: user_id, date: date).first
  end

  def self.giftable_dates(year = CURRENT_YEAR)
    1.upto(24).map { |day| Date.new(year, 12, day) }
  end

  def self.default_date
    @default_date ||= -> { Time.zone.now.to_date }
    @default_date.call
  end

  def self.format_gift_date date
    "#{ date.strftime('%B') } #{ date.mday.ordinalize }"
  end

  def to_param
    date.to_s
  end
end
