require 'rails_helper'

describe 'Static pages', type: :request do
  subject { page }
  let(:user) { create :user }

  describe 'home page' do
    before do
      2.times { create :project }
      5.times { create :contribution }
      visit root_path
    end

    it { is_expected.to have_button('Log in with GitHub') }
    it { is_expected.to have_content('7 Contributors already involved') }
    it { is_expected.to have_content('2 Suggested Projects') }
    it { is_expected.to have_link('View All', href: users_path) }
    it { is_expected.to have_link('View All', href: projects_path) }
    it { is_expected.to have_link('View All', href: pull_requests_path) }
    it { is_expected.to have_link('Suggest a project', href: new_project_path) }
    it { is_expected.to_not have_css('.featured_projects') }

  end

  context "homepage when it has featured projects" do
    before do
      create :project, name: 'foobar', featured: true
      visit root_path
    end
    it "show the featured project" do
      is_expected.to have_css('.featured_projects span.project-title', text: 'foobar')
    end
  end

  describe 'homepage in different dates' do
    context "during December" do
      it "doesnt show the finished partial on the first day" do
        Timecop.travel(Date.new(Tfpullrequests::Application.current_year, 12, 1))
        visit root_path
        is_expected.to_not have_content('24 Pull Requests is finished for')
      end

      it "doesnt show the finished partial on the last day" do
        Timecop.travel(Date.new(Tfpullrequests::Application.current_year, 12, 24))
        visit root_path
        is_expected.to_not have_content('24 Pull Requests is finished for')
      end
    end

    context "before November" do
      it "shows the finished partial" do
        Timecop.travel(Date.new(Tfpullrequests::Application.current_year, 10, 29))
        visit root_path
        is_expected.to have_content("24 Pull Requests is finished for #{Tfpullrequests::Application.current_year - 1 }")
      end
    end

    context "after Christmas" do
      it "shows the finished partial" do
        Timecop.travel(Date.new(Tfpullrequests::Application.current_year, 12, 25))
        visit root_path
        is_expected.to have_content("24 Pull Requests is finished for #{Tfpullrequests::Application.current_year }")
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
