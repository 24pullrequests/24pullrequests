require 'rails_helper'

describe 'Gifts', type: :request do
  subject { page }
  let(:user) { create :user, nickname: 'akira' }

  before do
    mock_is_admin
    login(user)
  end

  describe 'gifting a pull request' do
    let!(:contribution) { create(:contribution, user: user) }
    let!(:gift) { create(:gift, user: user, date: Date.yesterday) }

    before do
      visit new_gift_path
    end

    it 'only displays ungifted pull requests' do
      is_expected.not_to have_xpath "//option[contains(text(), 'Gifted')]"
      is_expected.to have_xpath "//option[contains(text(), 'Not gifted: #{contribution.repo_name}')]"
    end
  end
end
