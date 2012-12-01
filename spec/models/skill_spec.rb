require 'spec_helper'

describe Skill do
  let(:skill) { create :skill }

  it { should allow_mass_assignment_of(:language) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:language) }
end
