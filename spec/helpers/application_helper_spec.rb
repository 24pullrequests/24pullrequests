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

  end

end
