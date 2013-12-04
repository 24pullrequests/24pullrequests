require 'spec_helper'

describe ApplicationHelper do

  describe '#parameterize_language' do
    it 'parameterizes a language param' do
      helper.parameterize_language('Foo Bar').should eql('foo-bar')
    end

    it 'parameterizes a language param including a hash' do
      helper.parameterize_language('C#').should eql('csharp')
    end

    it 'parameterizes a language param including a plus' do
      helper.parameterize_language('C++').should eql('cpp')
    end
  end

  describe '#language_link' do
    it 'returns a link for a language' do
      helper.language_link('C#').should eql('<a data-language="c%23" href="#">c%23</a>')
    end

    it 'returns a link with a label' do
      helper.language_link('C#', 'Foobar').should eql('<a data-language="c%23" href="#">Foobar</a>')
    end

    it 'returns a link for multiple languages' do
      helper.language_link(['C#', 'Ruby'], 'Foobar').should eql('<a data-language="[&quot;c%23&quot;,&quot;ruby&quot;]" href="#">Foobar</a>')
    end

    it 'returns a link for multiple languages without a label' do
      helper.language_link(['C#', 'Ruby']).should eql('<a data-language="[&quot;c%23&quot;,&quot;ruby&quot;]" href="#">c%23, ruby</a>')
    end
  end

  describe '#gravatar_url' do
    it "returns a gravatar url with no digest, if none is set" do
      helper.gravatar_url.should eql("https://secure.gravatar.com/avatar/.png?s=80&d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png")
    end

    it "returns a gravatar url with the specified size, when size is defined" do
      helper.gravatar_url('andrew', 100).should eql("https://secure.gravatar.com/avatar/andrew.png?s=100&d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png")
    end
  end

  describe "#gittip_button" do
    it "returns a gittip button for the nickname" do
      resulting_html = "<a href=\"https://www.gittip.com/andrew/\"><img alt=\"Support via Gittip\" src=\"https://rawgithub.com/twolfson/gittip-badge/0.1.0/dist/gittip.png\"/> </a>"

      helper.gittip_button("andrew").should eql(resulting_html)
    end
  end

  describe '#contributing_url' do
    it 'returns an anchor tag with a link to the contributing section of 24pullrequests when no type is specified' do
      resulting_html = '<a href="http://24pullrequests.com/contributing">http://24pullrequests.com/contributing</a>'
      helper.contributing_url.should eql(resulting_html)
    end

    it 'returns just the url to the contribution section of 24pullrequests when type equals text' do
      url = 'http://24pullrequests.com/contributing'
      helper.contributing_url('text').should eql(url)
    end
  end

  describe '#twitter_url' do
    it 'returns an anchor tag with a link to the 24pullrequests page on Twitter when no type is specified' do
      resulting_html = '<a href="http://twitter.com/24pullrequests">http://twitter.com/24pullrequests</a>'
      helper.twitter_url.should eql(resulting_html)
    end

    it 'returns just the url to the 24pullrequests page on Twitter when type equals text' do
      url = 'http://twitter.com/24pullrequests'
      helper.twitter_url('text').should eql(url)
    end

  end

  describe '#preferences_url' do
    it 'returns an anchor tag with a link to the preferences section of 24pullrequests when no type is specified' do
      resulting_html = '<a href="http://24pullrequests.com/preferences">http://24pullrequests.com/preferences</a>'
      helper.preferences_url.should eql(resulting_html)
    end

    it 'returns just the url to the preferences section of 24pullrequests when type equals text' do
      url = 'http://24pullrequests.com/preferences'
      helper.preferences_url('text').should eql(url)
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

      helper.contributors_in(last_year).should eq(3)
    end

    it "pull_requests_in(year)" do
      3.times { create(:pull_request) }

      helper.pull_requests_in(last_year).should eq(3)
    end

    it "projects_in(year)" do
      3.times { create(:pull_request, repo_name: "24pullrequests", created_at: DateTime.now-1.year) }

      helper.projects_in(last_year).should eq(4)
    end
  end
end
