require 'spec_helper'
require 'ostruct'

describe User do
  let(:user) { create :user }

  it { should have_many(:pull_requests) }
  it { should have_many(:skills) }

  it { should accept_nested_attributes_for(:skills) }

  describe 'callbacks' do
    describe 'before_save' do
      describe '.check_email_changed' do
        subject { build :user }

        it 'is called if email changed' do
          subject.should_receive(:check_email_changed)
          subject.save
        end

        context 'email is present' do
          it 'generates a confirmation token' do
            subject.should_receive(:generate_confirmation_token)
            subject.save
          end

          it 'sends a confirmation email' do
            ConfirmationMailer.should_receive(:confirmation).and_return double("ConfirmationMailer", deliver: true)
            subject.save
          end
        end

        context 'email is blank' do
          before do
            subject.save
            subject.email = nil
          end

          it 'doesnt generate a confirmation token' do
            subject.should_not_receive(:generate_confirmation_token)
            subject.save
          end

          it 'doesnt send a confirmation email' do
            ConfirmationMailer.should_not_receive(:confirmation)
            subject.save
          end
        end
      end
    end
  end

  %w[daily weekly].each do |frequency|
    context "when user has subscribed to #{frequency} emails" do
      before do
        subject.email_frequency = frequency
      end

      it { should validate_presence_of(:email) }
    end
  end

  describe '#collaborators' do
    let!(:user) { create :user, :nickname => 'foobar' }

    before do
      3.times { create :user }
      Rails.configuration.stub(:collaborators).and_return([ Hashie::Mash.new(:login => 'foobar') ])
    end

    subject { described_class.collaborators }
    it { should eq [user] }
  end

  describe '.confirmed?' do
    subject { user }

    context 'email unconfirmed' do
      it 'returns false' do
        expect(subject).to_not be_confirmed
      end
    end

    context 'email confirmed' do
      before do
        subject.confirm!
      end

      it 'returns true' do
        expect(subject).to be_confirmed
      end
    end
  end

  describe '.confirm!' do
    subject { user }

    context 'no email configured' do
      before do
        subject.email = nil
      end

      it 'returns false' do
        expect(subject.confirm!).to be_false
      end

      it 'adds an error to the user email field' do
        subject.confirm!

        expect(subject.errors.messages[:email]).to include 'Email is required for confirmation'
      end
    end

    context 'email unconfirmed' do
      it 'returns true' do
        expect(subject.confirm!).to be_true
      end

      it 'sets the confirmed_at field' do
        subject.confirm!

        expect(subject.confirmed_at).to_not be_nil
      end

      it 'clears the confirmation_token field' do
        subject.confirm!

        expect(subject.confirmation_token).to be_nil
      end
    end

    context 'email already confirmed' do
      before do
        subject.confirm!
      end

      it 'returns false' do
        expect(subject.confirm!).to be_false
      end

      it 'adds an error to the user email field' do
        subject.confirm!

        expect(subject.errors.messages[:email]).to include 'Email is already confirmed'
      end
    end
  end

  describe '.generate_confirmation_token' do
    subject { user }

    before do
      subject.update_attribute(:confirmation_token, nil)
    end

    it 'generates a confirmation token' do
      subject.generate_confirmation_token

      expect(subject.confirmation_token).to_not be_nil
    end
  end

  describe '.check_email_changed' do
    subject { user }

    before do
      subject.confirm!
    end

    let!(:old_token) { subject.confirmation_token }

    context 'email didnt change' do
      before do
        subject.save
      end

      it 'doesnt reset the confirmed_at field' do
        expect(subject.confirmed_at).to_not be_nil
      end

      it 'doesnt send an email' do
        ConfirmationMailer.should_not_receive(:confirmation)

        subject.save
      end
    end

    context 'email did change' do
      before do
        subject.update_attribute(:email, 'another@email.addr')
      end

      it 'resets the confirmed_at field' do
        expect(subject.confirmed_at).to be_nil
      end

      it 'generates a new token' do
        expect(subject.confirmation_token).to_not eq old_token
      end

      it 'sends a confirmation email' do
        stub_mailer = double(ConfirmationMailer)
        stub_mailer.stub(:deliver)
        ConfirmationMailer.should_receive(:confirmation).and_return(stub_mailer)

        subject.update_attribute(:email, 'different@email.addr')
      end
    end
  end

  describe '.estimate_skills' do
    ENV['GITHUB_KEY'] = 'foobar'
    let(:github_client) { double('github client') }
    let(:repos) { Project::LANGUAGES.sample(3).map { |l| Hashie::Mash.new(:language => l) } }

    before do
      User.any_instance.unstub(:estimate_skills)
      User.any_instance.stub(:github_client).and_return(github_client)
      github_client.should_receive(:repos).and_return(repos)
    end

    subject { user }
    its(:skills) { should have(3).skills }
  end

  describe '.languages' do
    subject { user.languages }

    context 'when the user has no skillz' do
      it { should eq Project::LANGUAGES }
    end

    context 'when the user has skillz' do
      before do
        create :skill, :language => 'JavaScript', :user => user
      end

      it { should eq ['JavaScript'] }
    end
  end

  describe '.download_pull_requests' do
    let(:downloader)    { double('downloader') }
    let(:pull_request)  { mock_pull_request }

    before do
      downloader.should_receive(:pull_requests).and_return([pull_request])
      user.stub(:pull_request_downloader).and_return(downloader)
      user.download_pull_requests
    end

    subject { user.pull_requests }

    context 'when the pull request does not already exist' do
      its(:length) { should eq 1 }
    end

    context 'when the pull request already exists' do
      it { should_receive(:create).never }

      its(:length) { should eq 1 }
    end
  end

  describe '.pull_requests_count' do
    subject { user.pull_requests_count }

    context 'by default' do
      it { should eq 0}
    end

    context 'when a pull request is added' do
      before do
        create :pull_request, :user => user
        user.reload
      end

      it { should eq 1 }
    end
  end

  describe '.to_param' do
    subject { user.to_param }
    it { should eq user.nickname }
  end

  describe "gifting" do
    it "creates new gifts that belong to itself" do
      user.new_gift.user.should == user
    end

    it "forwards attributes to newly created gifts" do
      gift_factory = ->(attrs) { OpenStruct.new(attrs) }
      user.gift_factory = gift_factory

      user.new_gift(:foo => 'bar').foo.should == 'bar'
    end
  end

  describe '.is_collaborator?' do
    let(:collaborator) { create :user, nickname: "akira" }
    let(:non_collaborator) { create :user }

    before do
      User.should_receive(:collaborators).and_return([collaborator])
    end
    it 'identifies if a user is a collaborator' do
      collaborator.is_collaborator?.should eq(true)
    end

    it 'identifies if a user is not a collaborator' do
      non_collaborator.is_collaborator?.should eq(false)
    end
  end

  context "#scopes" do
    let!(:haskell_users) { 2.times.map { create(:skill, language: "Haskell").user } }

    it "by_language" do
      User.by_language("haskell").should eq(haskell_users)
      User.by_language("ruby").should eq([])
    end
  end

end
