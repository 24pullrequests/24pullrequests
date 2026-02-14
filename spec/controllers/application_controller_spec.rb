require 'rails_helper'

describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: Time.zone.name
    end
  end

  describe '#set_timezone' do
    before do
      routes.draw { get 'index' => 'anonymous#index' }
    end

    context 'when user is logged in with a timezone set' do
      let(:user) { create(:user, time_zone: 'Pacific Time (US & Canada)') }

      before do
        session[:user_id] = user.id
      end

      it 'sets Time.zone to the user timezone' do
        get :index
        expect(response.body).to eq('Pacific Time (US & Canada)')
      end
    end

    context 'when user is logged in without a timezone set' do
      let(:user) { create(:user, time_zone: nil) }

      before do
        session[:user_id] = user.id
      end

      it 'uses the default timezone' do
        original_timezone = Time.zone.name
        get :index
        expect(response.body).to eq(original_timezone)
      end
    end

    context 'when user is not logged in' do
      it 'uses the default timezone' do
        original_timezone = Time.zone.name
        get :index
        expect(response.body).to eq(original_timezone)
      end
    end
  end
end
