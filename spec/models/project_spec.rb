require 'spec_helper'

describe Project do
  let(:project) { create :project }

  it { should allow_mass_assignment_of(:description) }
  it { should allow_mass_assignment_of(:github_url) }
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:main_language) }

  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:github_url) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:main_language) }
  it { should validate_uniqueness_of(:github_url).with_message('already been submitted') }
  it { should ensure_length_of(:description).is_at_least(20).is_at_most(200) }

  describe '.github_url' do
    subject { project }

    context 'when a github url' do
      before do
        project.github_url = 'user/repo'
      end

      it { should be_valid }
      its(:github_url) { should eq 'https://github.com/user/repo' }
    end
  end
end
