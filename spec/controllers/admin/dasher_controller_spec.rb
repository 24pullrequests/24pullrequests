require 'rails_helper'

describe Admin::DasherController, type: :controller do
  around do |example|
    original_api_key = ENV['API_KEY']
    ENV['API_KEY'] = 'test-api-key'
    example.run
  ensure
    ENV['API_KEY'] = original_api_key
  end

  describe "POST 'new_pull_request'" do
    let(:user) { create(:user, nickname: 'octocat') }
    let(:base_payload) { mock_pull_request.merge('actor' => { 'login' => user.nickname }) }

    it 'returns unprocessable entity when payload cannot be persisted' do
      contributions = double(:contributions, create_from_github: nil)
      allow(User).to receive(:find_by_nickname).with(user.nickname).and_return(user)
      allow(user).to receive(:contributions).and_return(contributions)

      post :new_pull_request, params: base_payload.merge('api_key' => 'test-api-key')

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq('error' => 'Unable to persist pull request payload')
    end

    it 'returns success when user is not found' do
      allow(User).to receive(:find_by_nickname).with(user.nickname).and_return(nil)

      post :new_pull_request, params: base_payload.merge('api_key' => 'test-api-key')

      expect(response).to have_http_status(:ok)
    end

    it 'returns bad request when api key is invalid' do
      post :new_pull_request, params: base_payload.merge('api_key' => 'wrong-key')

      expect(response).to have_http_status(:bad_request)
    end
  end
end
