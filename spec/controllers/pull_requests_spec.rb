require 'spec_helper'

describe PullRequestsController do
  describe 'GET index' do
    context 'as json' do
      before do
        create :pull_request
        get :index, :format => :json
      end

      it { should respond_with_content_type(:json) }
    end
  end
end
