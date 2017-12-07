require 'rails_helper'

describe ApplicationHelper, type: :helper do

  describe '#parameterize_language' do
    it 'parameterizes a language param' do
      expect(helper.parameterize_language('Foo Bar')).to eql('foo-bar')
    end

    it 'parameterizes a language param including a hash' do
      expect(helper.parameterize_language('C#')).to eql('csharp')
    end

    it 'parameterizes a language param including a plus' do
      expect(helper.parameterize_language('C++')).to eql('cpp')
    end
  end

  describe '#language_link' do
    it 'returns a link for a language' do
      expect(helper.language_link('C#')).to eql('<a data-language="c%23" href="#">c%23</a>')
    end

    it 'returns a link with a label' do
      expect(helper.language_link('C#', 'Foobar')).to eql('<a data-language="c%23" href="#">Foobar</a>')
    end

    it 'returns a link for multiple languages' do
      expect(helper.language_link(['C#', 'Ruby'], 'Foobar')).to eql('<a data-language="[&quot;c%23&quot;,&quot;ruby&quot;]" href="#">Foobar</a>')
    end

    it 'returns a link for multiple languages without a label' do
      expect(helper.language_link(['C#', 'Ruby'])).to eql('<a data-language="[&quot;c%23&quot;,&quot;ruby&quot;]" href="#">c%23, ruby</a>')
    end
  end

  describe 'stats' do
    let(:user) { create(:user) }
    let(:last_year) { DateTime.now.year - 1 }

    before do
      3.times { create(:pull_request, user: user, repo_name: 'test_repo', created_at: DateTime.now - 1.year) }
    end

    it 'contributors_in(year)' do
      2.times { create(:pull_request, created_at: DateTime.now - 1.year) }

      expect(helper.contributors_in(last_year)).to eq(3)
    end

    it 'pull_requests_in(year)' do
      3.times { create(:pull_request) }

      expect(helper.pull_requests_in(last_year)).to eq(3)
    end

    it 'projects_in(year)' do
      create(:pull_request, repo_name: '24pullrequests', created_at: DateTime.now - 1.year)

      expect(helper.projects_in(last_year)).to eq(2)
    end
  end
end
