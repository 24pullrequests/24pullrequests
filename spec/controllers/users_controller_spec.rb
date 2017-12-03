require 'rails_helper'

describe UsersController, type: :controller do
  let(:user) { create :user }

  describe 'GET index' do
    before do
      create :user
    end

    context 'as html' do
      before do
        get :index
      end

      it { expect(assigns(:users).with(User.order('pull_requests_count desc').page(0))).to be_truthy }
    end

    context 'as json' do
      before do
        get :index, format: :json
      end

      it { expect(response.header['Content-Type']).to include 'application/json' }
    end
  end

  describe 'GET show' do
    context 'as html' do
      context 'when the case matches' do
        before do
          get :show, params: {id: user.nickname}
        end

        it { is_expected.to respond_with(200) }
      end

      context 'when the case does not match' do
        before do
          get :show, params: {id: user.nickname.upcase}
        end

        it { is_expected.to respond_with(200) }
      end
    end

    context 'as json' do
      before do
        get :show, params: {id: user.nickname}, format: :json
      end

      it { expect(response.header['Content-Type']).to include 'application/json' }
    end
  end

  describe 'GET unsubscribe' do
    context 'with valid token' do
      let!(:user) { create(:user, email_frequency: 'daily') }
      before do
        get :unsubscribe, params: { token: user.unsubscribe_token }
      end

      it { is_expected.to redirect_to root_path }
      it 'should have success flash' do
        expect(flash[:notice]).to eq I18n.t('unsubscribe.success')
      end
      it 'should unsubscribe user' do
        user.reload
        expect(user.email_frequency).to eq 'none'
      end
    end

    context 'with invalid token' do
      before do
        get :unsubscribe, params: { token: 'a' }
      end

      it { is_expected.to redirect_to root_path }
      it 'should have invalid_token flash' do
        expect(flash[:notice]).to eq I18n.t('unsubscribe.invalid_token')
      end
    end
  end
end
