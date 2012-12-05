require 'spec_helper'

describe 'Users' do
  subject { page }

  describe 'viewing the list of users' do
    before do
      5.times { create :user }
      visit users_path
    end

    it { should have_content '5 Developers already involved'}
  end

  describe 'viewing a specific user' do
    let(:user) { create :user }

    before do
      visit user_path(user)
    end
  end
end
