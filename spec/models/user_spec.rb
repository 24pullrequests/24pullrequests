require 'rails_helper'
require 'ostruct'

describe User, type: :model do
  let(:user) { create :user }

  it { is_expected.to have_many(:pull_requests) }
  it { is_expected.to have_many(:skills) }

  it { is_expected.to accept_nested_attributes_for(:skills) }

  describe 'callbacks' do
    describe 'before_save' do
      describe '.check_email_changed' do
        subject { build :user }

        it 'is called if email changed' do
          expect(subject).to receive(:check_email_changed)
          subject.save
        end

        context 'email is present' do
          it 'generates a confirmation token' do
            expect(subject).to receive(:generate_confirmation_token)
            subject.save
          end

          it 'sends a confirmation email' do
            expect(ConfirmationMailer).to receive(:confirmation).and_return double('ConfirmationMailer', deliver: true)
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
      subject.update_attribute(:confirmation_token, nil)
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
        allow(stub_mailer).to receive(:deliver)
        expect(ConfirmationMailer).to receive(:confirmation).and_return(stub_mailer)

        subject.update_attribute(:email, 'different@email.addr')
      end
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

  describe '.download_pull_requests', wip: true do
    let(:downloader)    { double('downloader', get_organisations: nil) }
    let(:pull_request)  { mock_pull_request }

    before(:each) do
      expect(Downloader).to receive(:new).and_return(downloader)
      expect(downloader).to receive(:get_pull_requests)

      user.download_pull_requests
    end

  end

  describe '.pull_requests_count' do
    subject { user.pull_requests_count }

    context 'by default' do
      it { is_expected.to eq 0 }
    end

    context 'when a pull request is added' do
      before do
        create :pull_request, user: user
        user.reload
      end

      it { is_expected.to eq 1 }
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

  describe '.is_admin?' do
    let(:admin) { create :user, nickname: 'akira' }
    let(:non_admin) { create :user }

    before do
      expect(User).to receive(:admins).and_return([admin])
    end
    it 'identifies if a user is a admin' do
      expect(admin.is_admin?).to eq(true)
    end

    it 'identifies if a user is not a admin' do
      expect(non_admin.is_admin?).to eq(false)
    end
  end

  context '#scopes' do
    let!(:haskell_users) { 2.times.map { create(:skill, language: 'Haskell').user } }

    it 'by_language' do
      expect(User.by_language('haskell')).to eq(haskell_users)
      expect(User.by_language('ruby')).to eq([])
    end
  end

end
