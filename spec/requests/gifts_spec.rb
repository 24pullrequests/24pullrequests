require 'spec_helper'

describe 'Gifts' do
	subject { page }
	let(:user) { create :user, nickname: "akira" }

	describe '#new' do
		before do
			let!(:pull_request) { create :pull_request, user: user }
			let!(:gift) 		{ create(:gift, user: user, pull_request: pull_request) }
		end

		should_not have_xpath "//option[contains(text(), '#{pull_request.title}')]"

		click_on "Gift it!"

		should_not have_xpath "//option[contains(text(), '#{pull_request.title}')]"
	end
end
