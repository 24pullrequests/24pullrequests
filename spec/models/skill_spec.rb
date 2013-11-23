require 'spec_helper'

describe Skill do
  let(:skill) { create :skill }

  it { should belong_to(:user) }
  it { should validate_presence_of(:language) }
end
