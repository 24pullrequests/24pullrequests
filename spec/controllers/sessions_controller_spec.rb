require 'rails_helper'

describe SessionsController, type: :controller do
  describe 'GET new' do
    before do
      get :new
    end

    it { is_expected.to redirect_to('/auth/github') }
  end

  describe 'POST create' do
    before do
      create :user, uid: 'uid', nickname: 'jane-doe', location: 'georgia'
    end

    it "updates the user's particulars" do
      expect(User.find_by_auth_hash(user_hash).location).to eq('georgia')

      request.env['omniauth.auth'] = user_hash # note new location!
      post :create, {provider: :github}, format: :json

      expect(User.find_by_auth_hash(user_hash).location).to eq('london')
    end
  end

  describe 'GET destroy' do
    before do
      session[:user_id] = 1
      get :destroy
    end

    it { is_expected.to_not set_session[:user_id] }
    it { is_expected.to redirect_to(root_path) }
  end

  describe 'GET failure' do
    before do
      get :failure, message: 'foobar'
    end

    it { is_expected.to set_flash[:notice].to('foobar') }
    it { is_expected.to redirect_to(root_path) }
  end
end

def user_hash
  { 'provider'    => 'github',
    'uid'         => 'uid',
    'info'        => {
      'nickname' => 'jane-doe'
    },
    'extra' => {
      'raw_info' => {
        'location' => 'london'
      }
    },
    'credentials' => { 'token' => 'some-token' } }
end
