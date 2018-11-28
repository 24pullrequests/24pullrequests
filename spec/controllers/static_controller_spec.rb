require 'rails_helper'

describe StaticController, type: :controller do
  describe 'GET about' do
    before do
      20.times do
        create(:contribution)
      end

      allow_any_instance_of(User).to receive(:high_rate_limit?).and_return(true)

      stub_request(:get, "https://api.github.com/repos/24pullrequests/24pullrequests/contributors?per_page=100").
        to_return(:status => 200, :body => [{ login: "andrew" }].to_json, headers: {'Content-Type' => 'application/json'})
    end
  end
end
