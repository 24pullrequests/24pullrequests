require 'spec_helper'

describe GithubUrl do
  it 'leaves a fully qualified url unchanged' do
    GithubUrl.normalize('https://github.com/fully/qualified').should eq('https://github.com/fully/qualified')
  end

  it 'normalizes an insecure scheme' do
    GithubUrl.normalize('http://github.com/unsecure/scheme').should eq('https://github.com/unsecure/scheme')
  end

  it 'normalizes a url with missing scheme' do
    GithubUrl.normalize('github.com/missing/scheme').should eq('https://github.com/missing/scheme')
  end

  it 'normalizes username/repo' do
    GithubUrl.normalize('username/repo').should eq('https://github.com/username/repo')
  end

  it 'normalizes username/repo with numbers' do
    GithubUrl.normalize('andrew/24pullrequests').should eq('https://github.com/andrew/24pullrequests')
    GithubUrl.normalize('2andrew/24pullrequests').should eq('https://github.com/2andrew/24pullrequests')
  end

  it 'normalizes a git repo' do
    GithubUrl.normalize('git@github.com:handle/code.git').should eq('https://github.com/handle/code')
  end

  it 'normalizes deeply linked github paths' do
    GithubUrl.normalize('http://github.com/your/project/some/path/to/file').should eq('https://github.com/your/project')
  end

  it 'leaves un-normalizable urls alone' do
    GithubUrl.normalize('arbitrary_string').should eq('arbitrary_string')
  end

end
