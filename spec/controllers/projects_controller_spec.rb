require 'spec_helper'

describe ProjectsController do
  let(:project) { create :project }

  describe 'GET index' do
    context 'as json' do
      before do
        create :project
        get :index, :format  => :json
      end

      it { response.header['Content-Type'].should include 'application/json' }
    end
  end
end
