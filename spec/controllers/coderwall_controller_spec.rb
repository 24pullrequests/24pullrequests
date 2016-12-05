require 'rails_helper'

describe CoderwallController, type: :controller do
  describe 'POST authorize' do
    let(:username) { 'testuser' }
    let(:github_username) { username }
    let(:coderwall_response) do
      { user: { accounts: { github: github_username } } }.to_json
    end
    let(:coderwall_url) { "https://coderwall.com/#{username}.json" }
    let(:error_no_user) { 'No user found with this name.' }
    let(:error_github_not_connected) { 'Please link your Coderwall account to your GitHub account and try again.' }
    let(:coderwall_success) { 'Successfully updated your Coderwall username!' }

    before do
      user = instance_double('User', nickname: username, change_coderwall_username!: true)
      allow(controller).to receive(:current_user).and_return(user)
      request.env['HTTP_REFERER'] = '/foo'
    end

    context 'when coderwall returns a HTTP Error' do
      before do
        stub_request(:get, coderwall_url)
          .to_return(status: [404, 'File Not Found'])
      end

      it 'returns an alert flash of error_no_user' do
        post :authorize, params: { user: { coderwall_username: username } }
        expect(flash[:alert]).to eq(error_no_user)
      end
    end

    context 'when there is a JSON parsing error' do
      before do
        stub_request(:get, coderwall_url)
          .to_return(body: 'not valid json')
      end

      it 'returns an alert flash of error_no_user' do
        post :authorize, params: { user: { coderwall_username: username } }
        expect(flash[:alert]).to eq(error_no_user)
      end
    end

    context 'when a different error occurs' do
      before do
        stub_request(:get, coderwall_url).to_raise(StandardError)
      end

      it 'raises the error' do
        expect {
          post :authorize, params: { user: { coderwall_username: username } }
        }.to raise_error(StandardError)
      end
    end

    context 'when coderwall github is not connected' do
      let(:github_username) { "differentuser" }
      before do
        stub_request(:get, coderwall_url).to_return(body: coderwall_response)
      end

      it 'returns an alert flash of error_github_not_connected' do
        post :authorize, params: { user: { coderwall_username: username } }
        expect(flash[:alert]).to eq(error_github_not_connected)
      end
    end

    context 'when username is updated successfully' do
      before do
        stub_request(:get, coderwall_url).to_return(body: coderwall_response)
      end

      it 'returns a success flash' do
        post :authorize, params: { user: { coderwall_username: username } }
        expect(flash[:notice]).to eq(coderwall_success)
      end
    end
  end
end
