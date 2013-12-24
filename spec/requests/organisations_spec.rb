require 'spec_helper'

describe 'Organisations' do
  subject { page }

  it "viewing a list of organisations" do
    3.times { create :organisation }
    visit organisations_path

    should have_content '3 organisations involved'
  end

  it "viewing an organization" do
    organisation = create(:organisation)
    sleep 0.05
    visit organisation_path(organisation)

    should have_content "0 pull requests submitted by members"
  end
end
