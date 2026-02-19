require 'rails_helper'

describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: Time.zone.name
    end
  end

  describe '.current_year' do
    around do |example|
      original_default_zone = Time.zone_default
      original_current_year = Tfpullrequests::Application.instance_variable_get(:@current_year)
      Time.zone_default = Time.find_zone!('UTC')
      Tfpullrequests::Application.instance_variable_set(:@current_year, nil)
      example.run
    ensure
      Time.zone_default = original_default_zone
      Tfpullrequests::Application.instance_variable_set(:@current_year, original_current_year)
    end

    it 'uses the default timezone year even when request timezone differs' do
      Timecop.travel(Time.utc(2026, 1, 1, 0, 30, 0)) do
        Time.use_zone('Pacific Time (US & Canada)') do
          expect(Tfpullrequests::Application.current_year).to eq(2026)
        end
      end
    end
  end

  describe '#set_timezone' do
    before do
      routes.draw { get 'index' => 'anonymous#index' }
    end

    around do |example|
      original_flag = ENV['ENABLE_USER_TIMEZONE']
      ENV['ENABLE_USER_TIMEZONE'] = enable_user_timezone
      example.run
    ensure
      ENV['ENABLE_USER_TIMEZONE'] = original_flag
    end

    let(:enable_user_timezone) { 'true' }

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
        get :index
        expect(response.body).to eq(Time.zone_default.name)
      end
    end

    context 'when user is logged in with an invalid timezone' do
      let(:user) { create(:user) }

      around do |example|
        original_zone = Time.zone
        begin
          example.run
        ensure
          Time.zone = original_zone
        end
      end

      before do
        Time.zone = 'Pacific Time (US & Canada)'
        user.update_column(:time_zone, 'Invalid/Timezone')
        session[:user_id] = user.id
      end

      it 'uses the default timezone' do
        get :index
        expect(response.body).to eq(Time.zone_default.name)
      end
    end

    context 'when user is not logged in' do
      it 'uses the default timezone' do
        get :index
        expect(response.body).to eq(Time.zone_default.name)
      end
    end

    context 'when timezone feature flag is disabled' do
      let(:enable_user_timezone) { 'false' }
      let(:user) { create(:user, time_zone: 'Pacific Time (US & Canada)') }

      before do
        session[:user_id] = user.id
      end

      it 'uses the default timezone' do
        get :index
        expect(response.body).to eq(Time.zone_default.name)
      end
    end

    context 'when timezone feature flag is not set' do
      let(:enable_user_timezone) { nil }
      let(:user) { create(:user, time_zone: 'Pacific Time (US & Canada)') }

      before do
        session[:user_id] = user.id
      end

      it 'uses the default timezone' do
        get :index
        expect(response.body).to eq(Time.zone_default.name)
      end
    end
  end
end
