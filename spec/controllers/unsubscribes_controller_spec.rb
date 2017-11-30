require 'rails_helper'

RSpec.describe UnsubscribesController, type: :controller do
  describe 'POST create' do
    context 'with an existing user' do
      let!(:user) { create(:user, email_frequency: 'daily') }

      context 'using user nickname' do
        before do
          post :create, params: { unsubscribe: { login: user.nickname } }
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

      context 'using user email' do
        before do
          post :create, params: { unsubscribe: { login: user.email } }
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
    end

    context 'without an existing user' do
      before do
        post :create, params: { unsubscribe: { login: 'test_user' } }
      end

      it { is_expected.to redirect_to root_path }
      it 'should have success flash' do
        expect(flash[:notice]).to eq I18n.t('unsubscribe.success')
      end
    end
  end
end
