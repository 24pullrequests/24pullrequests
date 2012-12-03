require 'spec_helper'

describe Project do
  it { should allow_mass_assignment_of(:description) }
  it { should allow_mass_assignment_of(:github_url) }
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:main_language) }

  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:github_url) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:main_language) }
  it { should validate_uniqueness_of(:github_url).with_message('Project has already been suggested.') }
  it { should ensure_length_of(:description).is_at_least(20).is_at_most(200) }
end
