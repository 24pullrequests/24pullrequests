class Gift < ApplicationRecord
  class << self
    attr_writer :default_date
  end

  belongs_to :user
  belongs_to :contribution

  validates :user, presence: true
  validates :contribution, presence: true
  validates :contribution, uniqueness: { message: 'you can only gift each contribution once!' }
  validates :date, presence:   true,
                   uniqueness: { scope:   :user_id,
                                 message: 'you only need one gift per day. Save it for tomorrow!' },
                   inclusion:  { in:      proc { Gift.giftable_dates },
                                 message: 'your gift should be for the month of December.' }

  delegate :title, :issue_url, to: :contribution, prefix: :contribution

  scope :year, -> (year) { where('EXTRACT(year FROM "created_at") = ?', year) }

  after_initialize do
    self.date ||= Gift.default_date
  end

  def self.find(user_id, date)
    where(user_id: user_id, date: date).first
  end

  def self.giftable_dates(year = Tfpullrequests::Application.current_year)
    1.upto(24).map { |day| Date.new(year, 12, day) }
  end

  def self.default_date
    @default_date ||= -> { Time.zone.now.to_date }
    @default_date.call
  end

  def self.format_gift_date(date)
    "#{date.strftime('%B')} #{date.mday.ordinalize}"
  end

  def to_param
    date.to_s
  end
end
