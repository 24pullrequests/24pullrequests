require 'rails_helper'
require 'rake'

describe 'db:seeds' do
  before do
    Rails.application.load_tasks
    Rake::Task['db:seed'].invoke
  end

  it 'db:seeds should eq 50' do
    expect(User.count).to eq(50)
  end
end
