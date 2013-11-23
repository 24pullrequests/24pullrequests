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
      helper.language_link('C#').should eql('<a data-language="csharp" href="#">csharp</a>')
    end

    it 'returns a link with a label' do
      helper.language_link('C#', 'Foobar').should eql('<a data-language="csharp" href="#">Foobar</a>')
    end

    it 'returns a link for multiple languages' do
      helper.language_link(['C#', 'Ruby'], 'Foobar').should eql('<a data-language="[&quot;csharp&quot;,&quot;ruby&quot;]" href="#">Foobar</a>')
    end

    it 'returns a link for multiple languages without a label' do
      helper.language_link(['C#', 'Ruby']).should eql('<a data-language="[&quot;csharp&quot;,&quot;ruby&quot;]" href="#">csharp, ruby</a>')
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

end
