require 'rails_helper'
require 'ostruct'

describe User, type: :model do
  let(:user) { create :user }

  it { is_expected.to have_many(:contributions) }
  it { is_expected.to have_many(:skills) }

  it { is_expected.to accept_nested_attributes_for(:skills) }

  it { should respond_to :unsubscribe_token }

  describe 'callbacks' do
    describe 'before_save' do
      describe '.check_email_changed' do
        subject { build :user }

        it 'is called if email changed' do
          expect(subject).to receive(:check_email_changed)
          subject.save
        end

        context 'email is present' do
          it 'sends a confirmation email' do
            expect(subject).to receive(:generate_confirmation_token)
            expect(ConfirmationMailer).to receive(:confirmation).and_return double('ConfirmationMailer', deliver_now: true)
            subject.save
          end
        end

        context 'email is blank' do
          before do
            subject.save
            subject.email = nil
          end

          it 'doesnt generate a confirmation token' do
            expect(subject).not_to receive(:generate_confirmation_token)
            subject.save
          end

          it 'doesnt send a confirmation email' do
            expect(ConfirmationMailer).not_to receive(:confirmation)
            subject.save
          end
        end
      end
    end

    describe 'before_validation' do
      describe '.generate_unsubscribe_token' do
        subject { build :user }

        it 'is called on valid?' do
          expect(subject).to receive(:generate_unsubscribe_token)
          subject.valid?
        end

        context 'unsubscribe_token is blank' do
          before do
            subject.unsubscribe_token = nil
          end

          it 'generates an unsubscribe_token' do
            subject.valid?
            expect(subject.unsubscribe_token).not_to be_nil
          end
        end

        context 'unsubscribe_token is not blank' do
          let!(:token) { SecureRandom.uuid }
          before do
            subject.unsubscribe_token = token
          end

          it 'does not override unsubscribe_token' do
            subject.valid?
            expect(subject.unsubscribe_token).to eq token
          end
        end
      end
    end
  end

  %w(daily weekly).each do |frequency|
    context "when user has subscribed to #{frequency} emails" do
      before do
        subject.email_frequency = frequency
      end

      it { is_expected.to validate_presence_of(:email) }
    end
  end

  describe '#admins' do
    let!(:user) { create :user, nickname: 'foobar' }

    before do
      3.times { create :user }
      allow(User).to receive(:organization_members).and_return([Hashie::Mash.new(login: 'foobar')])
    end

    subject { described_class.admins }
    it { is_expected.to eq [user] }
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
        expect(subject.confirm!).to be false
      end

      it 'adds an error to the user email field' do
        subject.confirm!

        expect(subject.errors.messages[:email]).to include 'Email is required for confirmation'
      end
    end

    context 'email unconfirmed' do
      it 'returns true' do
        expect(subject.confirm!).to be true
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
        expect(subject.confirm!).to be false
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
      subject.update_column(:confirmation_token, nil)
    end

    it 'generates a confirmation token' do
      subject.generate_confirmation_token

      expect(subject.confirmation_token).to_not be_nil
    end
  end

  describe '.avatar_url' do
    subject { user }

    its(:avatar_url) { is_expected.to eq "https://avatars.githubusercontent.com/u/#{user.uid}?size=80" }
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
        expect(ConfirmationMailer).not_to receive(:confirmation)

        subject.save
      end
    end

    context 'email did change' do
      before do
        subject.update(email: 'another@email.addr')
      end

      it 'resets the confirmed_at field' do
        expect(subject.confirmed_at).to be_nil
      end

      it 'generates a new token' do
        expect(subject.confirmation_token).to_not eq old_token
      end

      it 'sends a confirmation email' do
        stub_mailer = double(ConfirmationMailer)
        allow(stub_mailer).to receive(:deliver_now)
        expect(ConfirmationMailer).to receive(:confirmation).and_return(stub_mailer)

        subject.update(email: 'different@email.addr')
      end

      it 'still saves the user if email delivery fails' do
        stub_mailer = double(ConfirmationMailer)
        allow(stub_mailer).to receive(:deliver_now).and_raise(ArgumentError, 'SMTP-AUTH requested but missing user name')
        allow(ConfirmationMailer).to receive(:confirmation).and_return(stub_mailer)

        expect(subject.update(email: 'different@email.addr')).to be true
        expect(subject.reload.email).to eq 'different@email.addr'
      end
    end
  end

  describe '.send_confirmation_email' do
    subject { user }

    it 'returns true on success' do
      stub_mailer = double(ConfirmationMailer)
      allow(stub_mailer).to receive(:deliver_now)
      allow(ConfirmationMailer).to receive(:confirmation).and_return(stub_mailer)

      expect(subject.send_confirmation_email).to be true
    end

    it 'returns false when email delivery fails' do
      stub_mailer = double(ConfirmationMailer)
      allow(stub_mailer).to receive(:deliver_now).and_raise(ArgumentError, 'SMTP-AUTH requested but missing user name')
      allow(ConfirmationMailer).to receive(:confirmation).and_return(stub_mailer)

      expect(subject.send_confirmation_email).to be false
    end
  end

  describe '.estimate_skills' do
    ENV['GITHUB_KEY'] = 'foobar'
    let(:repo_languages) { Project::LANGUAGES.sample(3) }

    before do
      allow_any_instance_of(User).to receive(:estimate_skills).and_call_original
      allow_any_instance_of(User).to receive(:repo_languages).and_return(repo_languages)
    end

    subject { user }
    its(:skills) { should have(3).skills }
  end

  describe '.languages' do
    subject { user.languages }

    context 'when the user has no skillz' do
      it { is_expected.to eq Project::LANGUAGES }
    end

    context 'when the user has skillz' do
      before do
        create :skill, language: 'JavaScript', user: user
      end

      it { is_expected.to eq ['JavaScript'] }
    end
  end

  describe '.download_contributions', wip: true do
    let(:downloader)    { double('downloader', get_organisations: nil) }
    let(:contribution)  { mock_pull_request }

    before(:each) do
      expect(Downloader).to receive(:new).and_return(downloader)
      expect(downloader).to receive(:get_contributions)

      user.download_contributions
    end

  end

  describe '.contributions_count' do
    subject { user.contributions_count }

    context 'by default' do
      it { is_expected.to eq 0 }
    end

    context 'when a pull request is added' do
      before do
        create :contribution, user: user
        user.reload
      end

      it { is_expected.to eq 1 }
    end

    context 'with some pull requests filtered' do
      before do
        create :aggregation_filter, user: user, title_pattern: '% filtered'
        create(:contribution, user: user, title: 'should be included')
        create(:contribution, user: user, title: 'should be filtered')
      end

      it "should not include all the user's filtered requests in their aggregated count" do
        is_expected.to eq(user.contributions.all.count - 1)
      end
    end
  end

  describe '.contributions' do
    subject { user.contributions }

    context 'with some pull requests filtered' do
      before do
        create :aggregation_filter, user: user, title_pattern: '% filtered'
      end

      let(:included_pr) do
        create(:contribution, user: user, title: 'should be included')
      end

      let(:filtered_pr) do
        create(:contribution, user: user, title: 'should be filtered')
      end

      it 'should always show the full pull request list' do
        is_expected.to include included_pr
        is_expected.to include filtered_pr
      end
    end
  end

  describe '.to_param' do
    subject { user.to_param }
    it { is_expected.to eq user.nickname }
  end

  describe 'gifting' do
    it 'creates new gifts that belong to itself' do
      expect(user.new_gift.user).to eq(user)
    end

    it 'forwards attributes to newly created gifts' do
      gift_factory = ->(attrs) { OpenStruct.new(attrs) }
      user.gift_factory = gift_factory

      expect(user.new_gift(foo: 'bar').foo).to eq('bar')
    end
  end

  describe '.admin?' do
    let(:admin) { create :user, nickname: 'akira' }
    let(:non_admin) { create :user }

    before do
      expect(User).to receive(:admins).and_return([admin])
    end
    it 'identifies if a user is a admin' do
      expect(admin.admin?).to eq(true)
    end

    it 'identifies if a user is not a admin' do
      expect(non_admin.admin?).to eq(false)
    end
  end

  describe '.unsubscribe!' do
    subject { create(:user) }
    %w(daily weekly).each do |frequency|
      context "when user has subscribed to #{frequency} emails" do
        before do
          subject.email_frequency = frequency
          subject.save
        end

        it 'sets email_frequency to none' do
          subject.unsubscribe!
          expect(subject.email_frequency).to eq 'none'
        end
      end
    end
  end

  describe '#ignored_organisations_string' do
    before { user.ignored_organisations = %w{foo bar} }

    it "converts the organisations to a string" do
      expect(user.ignored_organisations_string).to eq("foo, bar")
    end
  end

  describe '#ignored_organisations_string=' do
    before { user.ignored_organisations_string = "foo,bar, moo,     oink," }

    it "converts the string of organisations to set of tags" do
      expect(user.ignored_organisations.to_set).to eq(%w{foo bar moo oink}.to_set)
    end
  end

  describe '#find_by_login' do
    let!(:user) { create(:user, email: 'TEST@example.com', nickname: 'TESTUSER') }

    context 'with valid nickname' do
      it 'finds user by nickname' do
        expect(User.find_by_login('testuser')).to eq user
      end
    end

    context 'with invalid nickname' do
      it 'does not find a user' do
        expect(User.find_by_login('foouser')).to be_nil
      end
    end

    context 'with valid email' do
      it 'finds user by email' do
        expect(User.find_by_login('test@example.com')).to eq user
      end
    end

    context 'with invalid email' do
      it 'does not find a user' do
        expect(User.find_by_login('foo@example.com')).to be_nil
      end
    end
  end

  context '#scopes' do
    let!(:haskell_users) { 2.times.map { create(:skill, language: 'Haskell').user } }

    it 'by_language' do
      expect(User.by_language('haskell')).to match_array(haskell_users)
      expect(User.by_language('ruby')).to eq([])
    end
  end
end
