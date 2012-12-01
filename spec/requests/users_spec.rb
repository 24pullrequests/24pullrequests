require 'spec_helper'

describe 'Users' do
  subject { page }

  describe 'viewing the list of users' do
    before do
      5.times do
        create :user
      end

      visit users_path
    end

    it { should have_content '5 Developers already involved'}
  end

  describe 'viewing a specific user' do
    let(:user) { create :user }

    before do
      visit user_path(user)
    end

    it { should have_content "#{user.nickname}'s Pull Requests"}
    it { should have_link('Github Profile', href: "https://github.com/#{user.nickname}") }

    context 'if the user has not submited any pull requests' do
      it { should have_content "hasn't sent any pull requests yet, what a grinch!" }
    end

    context 'if the user has submitted a pull request' do
      before do
        create :pull_request, user: user
        visit user_path(user)
      end

      it { should_not have_content "hasn't sent any pull requests yet, what a grinch!" }
    end
  end
end
