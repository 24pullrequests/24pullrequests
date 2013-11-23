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

  describe 'POST create mass assignment' do
    it "should allow mass assignment for certain parameters" do
      raw = {
        description: 'something or other waffling a bit to hit 20 characters or more',
        github_url: 'http://github.com/somebody/something',
        name: 'something',
        main_language: 'Ruby'
      }
      parameters = ActionController::Parameters.new(raw)
      expect {create :project, parameters}.not_to raise_error
    end

    it "should not allow mass assignment for others" do
      raw = {
        admin: 1
      }
      parameters = ActionController::Parameters.new(raw)
      expect {create :project, parameters}.to raise_error
    end
  end
end
