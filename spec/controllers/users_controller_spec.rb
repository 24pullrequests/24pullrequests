require 'rails_helper'

describe UsersController, :type => :controller do
  let(:user) { create :user }

  describe 'GET index' do
    before do
      create :user
    end

    context 'as html' do
      before do
        get :index
      end

      it { expect(assigns(:users).with(User.order('pull_requests_count desc').joins(:pull_requests).where('EXTRACT(year from pull_requests.created_at) = ?', CURRENT_YEAR).page(0) )).to be_truthy }
    end

    context 'as json' do
      before do
        get :index, :format  => :json
      end

      it { expect(response.header['Content-Type']).to include 'application/json' }
    end
  end

  describe 'GET show' do
    context 'as html' do
      context 'when the case matches' do
        before do
          get :show, :id  => user.nickname
        end

        it { is_expected.to respond_with(200) }
      end

      context 'when the case does not match' do
        before do
          get :show, :id  => user.nickname.upcase
        end

        it { is_expected.to respond_with(200) }
      end
    end

    context 'as json' do
      before do
        get :show, :id  => user.nickname, :format  => :json
      end

      it { expect(response.header['Content-Type']).to include 'application/json' }
    end
  end
end
