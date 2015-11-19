require 'rails_helper'

describe 'Static pages', type: :request do
  subject { page }
  let(:user) { create :user }

  describe 'home page' do
    before do
      2.times { create :project }
      5.times { create :pull_request }
      visit root_path
    end

    it { is_expected.to have_link('Log in with GitHub', href: login_path) }
    it { is_expected.to have_content('7 Developers already involved') }
    it { is_expected.to have_content('2 Suggested Projects') }
    it { is_expected.to have_link('View All', href: users_path) }
    it { is_expected.to have_link('View All', href: projects_path) }
    it { is_expected.to have_link('View All', href: pull_requests_path) }
    it { is_expected.to have_link('Suggest a project', href: new_project_path) }

  end

  describe 'homepage in different dates' do
    context "during December" do
      it "doesnt show the finished partial on the first day" do
        Timecop.travel(Date.new(CURRENT_YEAR, 12, 1))
        visit root_path
        is_expected.to_not have_content('24 Pull Requests is finished for')
      end

      it "doesnt show the finished partial on the last day" do
        Timecop.travel(Date.new(CURRENT_YEAR, 12, 24))
        visit root_path
        is_expected.to_not have_content('24 Pull Requests is finished for')
      end
    end

    context "not in December" do
      it "shows the finished partial" do
        Timecop.travel(Date.new(CURRENT_YEAR, 11, 30))
        visit root_path
        is_expected.to have_content('24 Pull Requests is finished for')
      end
    end
  end

  describe 'humans.txt' do
    before do
      allow(User).to receive(:contributors).and_return([user])

      visit humans_path(format: :txt)
    end

    it { is_expected.to have_content('CONTRIBUTORS') }
  end
end
