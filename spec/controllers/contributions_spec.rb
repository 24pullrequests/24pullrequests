require 'rails_helper'

describe ContributionsController, type: :controller do
  describe 'GET index' do
    context 'as json' do
      before do
        create :contribution
        get :index, format: :json
      end

      it { expect(response.header['Content-Type']).to include 'application/json' }
    end
  end
end
