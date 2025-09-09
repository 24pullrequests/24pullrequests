require 'rails_helper'

describe ProjectsController, type: :controller do
  let(:project) { create :project }

  describe 'GET index' do
    context 'as json' do
      before do
        create :project
        get :index, params: {format: :json}
      end

      it { expect(response.header['Content-Type']).to include 'application/json' }

      context 'pagination' do
        before { get :index, params: { format: :json, page: 101 } }

        it { expect(response).to be_forbidden }
      end
    end

    context 'filter' do
      let!(:ruby) do
        create_list :project, 5, main_language: 'Ruby'
      end

      let!(:python) do
        create_list :project, 5, main_language: 'Python'
      end

      it 'from params' do
        allow(ProjectSearch).to receive(:new).with({languages: %w(Ruby), labels: [], page: nil}).and_call_original
        get :index, params: {project: { languages: %w(Ruby) }}
        expect(assigns(:projects)).to match_array(ruby)
        expect(assigns(:has_more_projects)).to eq(false)
        expect(assigns(:languages)).to eq(%w(Ruby))
        expect(assigns(:labels)).to eq([])
        expect(session[:filter_options]).to eq(languages: %w(Ruby), labels: [])
      end

      it 'from session filter_options' do
        session[:filter_options] = { languages: %w(Ruby), labels: [] }
        allow(ProjectSearch).to receive(:new).with({languages: %w(Ruby), labels: [], page: nil}).and_call_original
        get :index
        expect(assigns(:projects)).to match_array(ruby)
        expect(assigns(:has_more_projects)).to eq(false)
        expect(assigns(:languages)).to eq(%w(Ruby))
        expect(assigns(:labels)).to eq([])
        expect(session[:filter_options]).to eq(languages: %w(Ruby), labels: [])
      end

      it 'from current_user languages' do
        allow(controller).to receive(:current_user).and_return(double('User', languages: %(Ruby)))
        allow(ProjectSearch).to receive(:new).with({ languages: %w(Ruby), labels: [], page: nil }).and_call_original
        get :index
        expect(assigns(:projects)).to match_array(ruby)
        expect(assigns(:has_more_projects)).to eq(false)
        expect(assigns(:languages)).to eq(%w(Ruby))
        expect(assigns(:labels)).to eq([])
        expect(session[:filter_options]).to eq({ languages: %w(Ruby), labels: [] })
      end

      it 'searches all projects with empty arrays' do
        allow(ProjectSearch).to receive(:new).with({ languages: [], labels: [], page: nil }).and_call_original
        get :index, params: {project: { languages: [], labels: [] }}
        expect(assigns(:projects).length).to eq(10)
        expect(assigns(:has_more_projects)).to eq(false)
        expect(assigns(:languages)).to eq([])
        expect(assigns(:labels)).to eq([])
        expect(session[:filter_options]).to eq({ languages: [], labels: [] })
      end

      it 'label is passed to search' do
        allow(ProjectSearch).to receive(:new).with({ languages: [], labels: %w(foo), page: nil }).and_call_original
        get :index, params: {project: { languages: [], labels: %w(foo) }}
        expect(assigns(:labels)).to eq(%w(foo))
        expect(session[:filter_options]).to eq({ languages: [], labels: %w(foo) })
      end
    end
  end

  describe 'POST create mass assignment' do
    it 'should allow mass assignment for certain parameters' do
      raw = {
        description:   'something or other waffling a bit to hit 20 characters or more',
        github_url:    'http://github.com/somebody/something',
        homepage:      'http://homepage.github.com',
        name:          'something',
        main_language: 'Ruby'
      }
      parameters = ActionController::Parameters.new(raw).permit!.to_h
      expect { create :project, parameters }.not_to raise_error
    end

    it 'should not allow mass assignment for others' do
      raw = {
        admin: 1
      }
      parameters = ActionController::Parameters.new(raw)
      expect { create :project, parameters }.to raise_error KeyError
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
        post :claim, params: {project: { github_url: unclaimed_project.github_url }}
        expect(flash[:notice]).not_to be_nil
        expect(flash[:notice]).to eq "You have successfully claimed <b>#{unclaimed_project.github_url}</b>"
      end
    end

    describe 'failed claim' do
      it 'should fail when claiming an already claimed project' do
        post :claim, params: {project: { github_url: claimed_project.github_url }}
        expect(flash[:notice]).not_to be_nil
        expect(flash[:notice]).to eq "This repository doesn't exist or belongs to someone else"
      end
    end
  end

  describe 'GET autofill' do
    context 'Logged in' do
      let(:user) { create(:user) }

      before do
        session[:user_id] = user.id
      end

      it 'Repo with labels' do
        allow(controller).to receive(:repo_with_labels)
          .with('24pullrequests/24pullrequests')
          .and_return({
            data: {
              repository: { html_url: "/foo" },
              labels: ['foo', 'bar']
            },
            status: 200
          })

        get :autofill, params: {repo: '24pullrequests/24pullrequests'}

        expect(response.status).to eq(200)

        expect(JSON.parse(response.body)).to eq({
          "repository" => { "html_url" => "/foo" },
          "labels" => ['foo', 'bar']
        })
      end

      it "Removes trailing slashes" do
        allow(controller).to receive(:repo_with_labels)
          .with('24pullrequests/24pullrequests')
          .and_return({
            data: {
              repository: { html_url: "/foo" },
              labels: ['foo', 'bar']
            },
            status: 200
          })

        get :autofill, params: {repo: '24pullrequests/24pullrequests/'}

        expect(response.status).to eq(200)

        expect(JSON.parse(response.body)).to eq({
          "repository" => { "html_url" => "/foo" },
          "labels" => ['foo', 'bar']
        })


      end

    end

    it 'Logged out' do
      get :autofill, params: {repo: '24pullrequests/24pullrequests'}
      expect(response).to redirect_to(login_path)
    end
  end
end
