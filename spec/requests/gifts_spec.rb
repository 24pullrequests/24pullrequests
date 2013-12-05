require 'spec_helper'

describe 'Gifts' do
	subject { page }
	let(:user) { create :user, nickname: "akira" }

	describe 'multiple giftings of a pull request' do
		before do
			login(user)
			visit new_gift_path
		end

		let(:pull_request) { create(:pull_request, user: user, title: 'Example Pull Request') }
		let(:gift) { create(:gift, user: user, pull_request: pull_request) }

		it 'should not have any pull requests available' do
			should_not have_xpath "//option[contains(text(), '#{pull_request.title}')]"

			click_on "Gift it!"

			should_not have_xpath "//option[contains(text(), '#{pull_request.title}')]"
		end
	end
end
