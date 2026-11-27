require 'rails_helper'

describe 'Remembering the project language filter', type: :request do
  subject { page }

  before do
    create :project, name: 'Ruby project', main_language: 'Ruby'
    create :project, name: 'Java project', main_language: 'Java'
  end

  it 'keeps the chosen languages on the next visit' do
    visit projects_path(project: { languages: ['Ruby'] })
    visit projects_path

    is_expected.to have_content 'Ruby project'
    is_expected.not_to have_content 'Java project'
  end
end
