require 'rails_helper'

describe Label, type: :model do
  subject { Label.new }

  context 'validations' do
    it 'must have a name' do
      is_expected.to have(1).error_on(:name)
    end

    it 'the name must be unique' do
      Label.create name: 'documentation'
      label = Label.create name: 'documentation'

      expect(label).to have(1).error_on(:name)
    end
  end
end
