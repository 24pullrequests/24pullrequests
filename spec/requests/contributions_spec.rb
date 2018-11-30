require 'rails_helper'

describe 'Contribution', type: :request do
  subject { page }

  describe 'viewing the list of users' do
    before do
      5.times { create :contribution }
      visit pull_requests_path
    end

    it { is_expected.to have_content '5 contributions already made!' }
  end

  describe 'Users' do
    before do
      user = create :user
      create :contribution, user: user
      create :contribution, user_id: nil
      visit pull_requests_path
    end

    it 'Only show the image when there is a user' do
      expect(page.all('.contribution a.image').length).to eq(1)
    end
  end
end
