require 'spec_helper'

## We'll assume a system-level install for testing purposes
describe file('/usr/local/rbenv') do
  it { should be_directory }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/usr/local/rbenv/bin/rbenv') do
  it { should be_file }
  it { should be_executable }
  it { should be_executable.by('others') }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe command('bash -l -c "which rbenv"') do
  its(:stdout) { should match /\/usr\/local\/rbenv\/bin\/rbenv/ }
  it { should return_exit_status 0 }
end

describe command('bash -l -c "rbenv --version"') do
  its(:stdout) { should match /0\.4\.0/ }
  it { should return_exit_status 0 }
end