require 'rails_helper'

describe ProjectsController, type: :controller do
  let(:project) { create :project }

  describe 'GET index' do
    context 'as json' do
      before do
        create :project
        get :index, format: :json
      end

      it { expect(response.header['Content-Type']).to include 'application/json' }
    end

    context 'with stored session preferences' do
      before do
        session[:filter_options] = { languages: %w(Ruby JavaScript) }
        get :index, format: :html
      end

      it { expect(assigns(:current_user_languages)).to contain_exactly('Ruby', 'JavaScript') }
    end
  end

  describe 'POST create mass assignment' do
    it 'should allow mass assignment for certain parameters' do
      raw = {
        description:   'something or other waffling a bit to hit 20 characters or more',
        github_url:    'http://github.com/somebody/something',
        name:          'something',
        main_language: 'Ruby'
      }
      parameters = ActionController::Parameters.new(raw)
      expect { create :project, parameters }.not_to raise_error
    end

    it 'should not allow mass assignment for others' do
      raw = {
        admin: 1
      }
      parameters = ActionController::Parameters.new(raw)
      expect { create :project, parameters }.to raise_error NoMethodError 
    end
  end

  describe 'GET filter' do
    before do
      5.times do
        create :project, main_language: 'Ruby'
        create :project, main_language: 'JavaScript'
        create :project, main_language: 'Python'
      end
      2.times { |_i| create :project, main_language: 'Lua' }
    end

    it 'should do only return filter projects' do
      xhr :get, :filter, format: :js, project: { languages: ['Ruby'] }
      expect(assigns(:projects).size).to eq 5
      expect(assigns(:projects).map(&:main_language).uniq).to eq ['Ruby']

      xhr :get, :filter, format: :js, project: { languages: %w(JavaScript Lua) }
      expect(assigns(:projects).size).to eq 7
      expect(assigns(:projects).map(&:main_language).uniq).to include 'JavaScript', 'Lua'
    end

    it 'should store filter values in session' do
      xhr :get, :filter, format: :js, project: { languages: ['Ruby'] }

      expect(session[:filter_options]).not_to be_nil
      expect(session[:filter_options][:labels]).to eq([])
      expect(session[:filter_options][:languages]).to contain_exactly('Ruby')

      xhr :get, :filter, format: :js, project: { languages: %w(JavaScript Lua), labels: ['refactoring'] }

      expect(session[:filter_options]).not_to be_nil
      expect(session[:filter_options][:labels]).to contain_exactly('refactoring')
      expect(session[:filter_options][:languages]).to contain_exactly('JavaScript', 'Lua')
    end
  end

  describe 'POST claim' do
    let(:unclaimed_project) { create :project, submitted_by: nil }
    let(:user) { create(:user) }
    let(:claimed_project) { create :project }

    before do
      @request.env['HTTP_REFERER'] = 'http://test.com/sessions/new'
      session[:user_id] = user.id
    end

    describe 'successful claim' do
      it 'should successfully claim ownership of an unclaimed project' do
        post :claim,  project: { github_url: unclaimed_project.github_url }
        expect(flash[:notice]).not_to be_nil
        expect(flash[:notice]).to eq "You have successfully claimed <b>#{unclaimed_project.github_url}</b>"
      end
    end

    describe 'failed claim' do
      it 'should fail when claiming an already claimed project' do
        post :claim,  project: { github_url: claimed_project.github_url }
        expect(flash[:notice]).not_to be_nil
        expect(flash[:notice]).to eq "This repository doesn't exist or belongs to someone else"
      end
    end

  end
end
