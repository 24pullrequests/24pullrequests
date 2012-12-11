class DataClip < ActiveRecord::Base
  attr_accessible :title, :url, :json, :chart_type
  
  def payload_data
    JSON.parse(payload)
  end
  
  def self.predefined
    [
      {
        :title => 'Signups by Day',
        :url => 'https://dataclips.heroku.com/okqzozawksjmtqpcdgrslcmolbhg',
        :chart_type =>  'line'
      },
      {
        :title => 'Pull Requests by Day',
        :url => 'https://dataclips.heroku.com/lqkxmuvujprffvysugrmdyykexel',
        :chart_type => 'line'
      }
    ]

  end
end