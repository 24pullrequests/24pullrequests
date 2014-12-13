require 'rails_helper'

describe 'Twitter', type: :request do
  let(:user) { create :user, email_frequency: 'never' }
  subject { page }

  before do
    allow_any_instance_of(User).to receive(:admin?) { false }
    login user
    visit dashboard_path
    click_on 'Profile'
  end

   describe 'Linking twitter account' do
     context 'when the user has not linked their twitter account' do
       it { should have_link('Link Your Twitter Account', :href => '/auth/twitter') }

       it 'allows the user to link their twitter account' do
         mock_twitter_auth
         click_on 'Link Your Twitter Account'
         expect(page).to have_content("Your Twitter account has been linked! We’ll post a tweet whenever you open a pull request.")
         user.reload
         expect(user).to be_twitter_linked
       end
     end

     context 'when the user has already linked their twitter account' do
       let(:user) { create :user, :email_frequency => 'never', :twitter_token => 'foo', :twitter_secret => 'bar' }
       it { should_not have_link('Link Your Twitter Account') }
     end
   end

   describe 'removing twitter account' do
     context 'when the user has linked their twitter account' do
       let(:user) { create :user, :email_frequency => 'never',
                    :twitter_nickname => Faker::Lorem.word,
                    :twitter_token => SecureRandom.hex,
                    :twitter_secret => SecureRandom.hex }

       it { should have_link("@#{user.twitter_nickname}", :href  => "https://twitter.com/#{user.twitter_nickname}")}
       it { should have_link('Unlink Twitter Account', :href  => twitter_remove_path) }

       describe 'clicking remove account' do
         before do
           click_on 'Unlink Twitter Account'
         end

         it { should have_content 'Your Twitter account has been removed.' }
         it { should_not have_link('Unlink Twitter Account') }
       end
     end
   end
end
