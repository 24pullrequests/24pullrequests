require 'rails_helper'

describe DashboardsController, type: :controller do
  describe '#today' do
    let(:boundary_time) { Time.utc(2026, 1, 1, 0, 30, 0) }

    it 'uses the default timezone date boundary' do
      Timecop.travel(boundary_time) do
        default_result = Time.use_zone(Time.zone_default) { Time.zone.now.to_date }
        pacific_result = Time.use_zone('Pacific Time (US & Canada)') { controller.send(:today) }

        expect(pacific_result).to eq(default_result)
      end
    end
  end

  describe '#giftable_range?' do
    let(:current_year) { Tfpullrequests::Application.current_year }
    let(:boundary_time) { Time.utc(current_year, 12, 24, 0, 30, 0) }

    it 'uses the default timezone season boundary' do
      Timecop.travel(boundary_time) do
        default_result = Time.use_zone(Time.zone_default) { controller.send(:giftable_range?) }
        pacific_result = Time.use_zone('Pacific Time (US & Canada)') { controller.send(:giftable_range?) }

        expect(pacific_result).to eq(default_result)
      end
    end
  end

  describe 'GET resend_confirmation_email' do
    let(:confirmation_message) do
      'Confirmation email sent. Please check your inbox.'
    end

    before do
      user = instance_double('User', send_confirmation_email: true, email_frequency: 'daily')
      allow(controller).to receive(:current_user).and_return(user)
    end

    it 'Redirect when referer is set' do
      request.env['HTTP_REFERER'] = '/foo'
      get :resend_confirmation_email
      expect(response).to redirect_to('/foo')
      expect(flash[:notice]).to eq(confirmation_message)
    end

    it 'Redirect to dashboard when no referer is set' do
      request.env['HTTP_REFERER'] = nil
      get :resend_confirmation_email
      expect(response).to redirect_to(dashboard_path)
      expect(flash[:notice]).to eq(confirmation_message)
    end

    context 'when email delivery fails' do
      before do
        user = instance_double('User', send_confirmation_email: false, email_frequency: 'daily')
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'shows an error message' do
        get :resend_confirmation_email
        expect(response).to redirect_to(dashboard_path)
        expect(flash[:alert]).to eq('Unable to send confirmation email. Please try again later.')
      end
    end
  end
end
