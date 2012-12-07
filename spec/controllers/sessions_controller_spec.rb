require 'spec_helper'

describe SessionsController do
  describe 'GET new' do
    before do
      get :new
    end

    it { should redirect_to('/auth/github') }
  end

  describe 'GET destroy' do
    before do
      session[:user_id] = 1
      get :destroy
    end

    it { should set_session(:user_id).to(nil) }
    it { should redirect_to(root_path) }
  end

  describe 'GET failure' do
    before do
      get :failure, :message => 'foobar'
    end

    it { should set_the_flash[:notice].to('foobar') }
    it { should redirect_to(root_path)}
  end
end
