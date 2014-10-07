require 'rails_helper'

describe ApplicationHelper, :type => :helper do

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

  describe '#gravatar_url' do
    it "returns a gravatar url with no digest, if none is set" do
      expect(helper.gravatar_url).to eql("https://secure.gravatar.com/avatar/.png?s=80&d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png")
    end

    it "returns a gravatar url with the specified size, when size is defined" do
      expect(helper.gravatar_url('andrew', 100)).to eql("https://secure.gravatar.com/avatar/andrew.png?s=100&d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png")
    end
  end

  describe "#gittip_button" do
    it "returns a gittip button for the nickname" do
      resulting_html = "<a href=\"https://www.gittip.com/andrew/\" class=\"btn btn-success btn-lg\"><span class=\"glyphicon glyphicon-heart\"></span>Support via Gittip</a>"

      expect(helper.gittip_button("andrew")).to eql(resulting_html)
    end
  end

  describe '#contributing_url' do
    it 'returns an anchor tag with a link to the contributing section of 24pullrequests when no type is specified' do
      resulting_html = '<a href="http://24pullrequests.com/contributing">http://24pullrequests.com/contributing</a>'
      expect(helper.contributing_url).to eql(resulting_html)
    end

    it 'returns just the url to the contribution section of 24pullrequests when type equals text' do
      url = 'http://24pullrequests.com/contributing'
      expect(helper.contributing_url('text')).to eql(url)
    end
  end

  describe '#twitter_url' do
    it 'returns an anchor tag with a link to the 24pullrequests page on Twitter when no type is specified' do
      resulting_html = '<a href="http://twitter.com/24pullrequests">http://twitter.com/24pullrequests</a>'
      expect(helper.twitter_url).to eql(resulting_html)
    end

    it 'returns just the url to the 24pullrequests page on Twitter when type equals text' do
      url = 'http://twitter.com/24pullrequests'
      expect(helper.twitter_url('text')).to eql(url)
    end

  end

  describe '#preferences_url' do
    it 'returns an anchor tag with a link to the preferences section of 24pullrequests when no type is specified' do
      resulting_html = '<a href="http://24pullrequests.com/preferences">http://24pullrequests.com/preferences</a>'
      expect(helper.preferences_url).to eql(resulting_html)
    end

    it 'returns just the url to the preferences section of 24pullrequests when type equals text' do
      url = 'http://24pullrequests.com/preferences'
      expect(helper.preferences_url('text')).to eql(url)
    end
  end

  describe "stats" do
    let(:user) { create(:user) }
    let(:last_year) { DateTime.now.year-1 }

    before do
      3.times { create(:pull_request, user: user, created_at: DateTime.now-1.year) }
    end

    it "contributors_in(year)" do
      2.times { create(:pull_request, created_at: DateTime.now-1.year) }

      expect(helper.contributors_in(last_year)).to eq(3)
    end

    it "pull_requests_in(year)" do
      3.times { create(:pull_request) }

      expect(helper.pull_requests_in(last_year)).to eq(3)
    end

    it "projects_in(year)" do
      3.times { create(:pull_request, repo_name: "24pullrequests", created_at: DateTime.now-1.year) }

      expect(helper.projects_in(last_year)).to eq(4)
    end
  end
end
