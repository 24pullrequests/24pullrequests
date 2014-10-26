require 'rails_helper'

describe 'Organisations', :type => :request do
  subject { page }

  it "viewing a list of organisations" do
    3.times { create :organisation }
    visit organisations_path

    is_expected.to have_content '3 organisations involved'
  end

  it "viewing an organization" do
    organisation = create(:organisation)
    sleep 6
    visit organisation_path(organisation)

    is_expected.to have_content "0 pull requests submitted by members"
  end
end
