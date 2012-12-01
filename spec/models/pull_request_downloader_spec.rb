require 'spec_helper'

describe PullRequestDownloader do
  let(:pull_request_downloader) { described_class.new 'foobar', 'Aet8Boux' }

  describe '.pull_requests' do
    let(:event) do
      double('event').tap do |event|
        event.stub(:type).and_return('PullRequestEvent')
        event.stub_chain(:payload, :action).and_return('opened')
        event.stub(:[]).with('created_at').and_return('24/12/2012')
      end
    end

    before do
      Octokit::Client.any_instance.should_receive(:user_events).and_return([event])
    end

    subject { pull_request_downloader.pull_requests }
    it { should eq [event] }
  end
end
