require 'rails_helper'

describe ProjectHelper, type: :helper do
  describe '#safe_http_url' do
    it 'returns http and https urls' do
      expect(helper.safe_http_url('https://github.com/octocat/hello')).to eq('https://github.com/octocat/hello')
      expect(helper.safe_http_url('http://example.com')).to eq('http://example.com')
    end

    it 'returns nil for other schemes and blank values' do
      expect(helper.safe_http_url('javascript:alert(1)')).to be_nil
      expect(helper.safe_http_url('data:text/html,hi')).to be_nil
      expect(helper.safe_http_url('')).to be_nil
      expect(helper.safe_http_url(nil)).to be_nil
    end
  end
end
