require 'rails_helper'
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

describe Coderwall do
  subject(:coderwall) { Coderwall.new }

  before do
    stub_const('ENV', 'CODERWALL_API_KEY' => 'the-key')
  end

  describe '#configured?' do
    it 'is not configured when there is not api key set' do
      stub_const('ENV', {})

      expect(coderwall.configured?).to be(false)
    end

    it 'is configured when the api key is set' do

      expect(coderwall.configured?).to be(true)
    end
  end

  describe '#award_badge' do
    it 'awards a participant badge' do
      stub_const('CURRENT_YEAR', '2014')
      payload = { github:  'akira',
                  badge:   'TwentyFourPullRequestsParticipant2014',
                  date:    '12/25/2014',
                  api_key: 'the-key' }

      expect(coderwall.connection).to receive(:post)

      stub_request(:post, "https://coderwall.com/award").
         with(:body => payload, :headers => {'Accept'=>'application/json',
         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
         to_return(:status => 200, :body => "", :headers => {})

      coderwall.award_badge('akira', Coderwall::PARTICIPANT)
    end

  end
end
