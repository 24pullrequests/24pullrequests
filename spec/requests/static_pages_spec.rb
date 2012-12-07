require 'spec_helper'

describe 'Static pages' do
  subject { page }

  describe 'home page' do
    before do
      5.times { create :user }
      2.times { create :project }
      visit root_path
    end

    it { should have_link('Log in with GitHub', :href  => login_path) }
    it { should have_content('5 Developers already involved') }
    it { should have_content('2 Suggested Projects') }
    it { should have_link('View All', :href  => users_path) }
    it { should have_link('View All', :href  => projects_path) }
    it { should have_link('View All', :href  => pull_requests_path) }
    it { should have_link('Suggest a project', :href  => new_project_path) }
  end
end
