require 'rails_helper'

describe DashboardsController, type: :controller do
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
  end
end
