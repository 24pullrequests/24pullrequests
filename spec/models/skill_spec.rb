require 'rails_helper'

describe Skill, type: :model do
  let(:skill) { create :skill }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:language) }
end
