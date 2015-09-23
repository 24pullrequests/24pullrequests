require 'rails_helper'

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
      stub_const('CURRENT_YEAR', '2015')
      payload = { github:  'akira',
                  badge:   'TwentyFourPullRequestsParticipant2015',
                  date:    '12/25/2015',
                  api_key: 'the-key' }

#FIXME:      expect(coderwall.connection).to receive(:post).with('/award', payload)

#FIXME:      coderwall.award_badge('akira', Coderwall::PARTICIPANT)
    end

  end
end
