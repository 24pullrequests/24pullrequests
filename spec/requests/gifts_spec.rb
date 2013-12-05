require 'spec_helper'

describe 'Gifts' do
	subject { page }
	let(:user) { create :user, nickname: "akira" }

	describe '#new'
		before do
			let!(:pull_request) { create :pull_request, user: user }
			let!(:gift) 		{ create(:gift, user: user, pull_request: pull_request)
		end

		it { should not have_selector('option') }

		click_on "Gift it!"

		it { should not have_selector('option') }
	end
end