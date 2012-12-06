require 'spec_helper'

describe UsersController do
  let(:user) { create :user }

  describe 'GET index' do
    before do
      create :user
    end

    context 'as html' do
      before do
        get :index
      end

      it { should assign_to(:users).with(User.order('pull_requests_count desc').page(0)) }
    end

    context 'as json' do
      before do
        get :index, format: :json
      end

      it { should respond_with_content_type(:json) }
    end
  end

  describe 'GET show' do
    context 'as html' do
      context 'when the case matches' do
        before do
          get :show, id: user.nickname
        end

        it { should respond_with(200) }
      end

      context 'when the case does not match' do
        before do
          get :show, id: user.nickname.upcase
        end

        it { should respond_with(200) }
      end
    end

    context 'as json' do
      before do
        get :show, id: user.nickname, format: :json
      end

      it { should respond_with_content_type(:json) }
    end
  end
end
