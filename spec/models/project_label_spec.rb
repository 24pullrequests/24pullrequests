require 'rails_helper'

describe ProjectLabel, type: :model do
  subject { ProjectLabel.new }

  context 'validations' do
    it 'must have a label' do
      is_expected.to validate_presence_of(:label_id)
    end

    it 'must only have a label allocated to a project once' do
      is_expected.to validate_uniqueness_of(:label_id).scoped_to(:project_id)
    end
  end
end
