require 'rails_helper'

describe SessionsController, type: :controller do
  describe 'GET new' do
    before do
      get :new
    end

    it { is_expected.to redirect_to('/auth/github') }
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
