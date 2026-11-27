require 'rails_helper'
require 'rake'

describe 'db:seeds' do
  before do
    Rails.application.load_tasks
    Rake::Task['db:seed'].invoke
  end

  it 'creates users with contributions, projects and events' do
    expect(User.count).to eq(5)
    expect(Project.count).to eq(5)
    expect(Contribution.count).to be >= 15
    expect(Event.count).to eq(4)
  end
end
