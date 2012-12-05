require 'spec_helper'

describe UsersController do
  let(:user) { create :user }

  describe 'GET index' do
    before do
      get :index
    end

    it { should assign_to(:users).with(User.order('pull_requests_count desc').page(0)) }
  end

  describe 'GET show' do
    context 'when the case matches' do
      before do
        get :show, id: user.nickname
      end

      it { should respond_with(200) }
    end

    context 'when the case does not match' do
      before do
        get :show, id: user.nickname.upcase
      end

      it { should respond_with(200) }
    end
  end
end
