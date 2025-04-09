require 'rails_helper'

describe 'Contribution', type: :request do
  subject { page }

  describe 'viewing the list of users' do
    before do
      5.times { create :contribution }
      visit pull_requests_path
    end

    it { is_expected.to have_content '5 contributions already made!' }
  end

  describe 'Users' do
    before do
      user = create :user
      create :contribution, user: user
      create :contribution, user_id: nil
      visit pull_requests_path
    end

    it 'Only show the image when there is a user' do
      expect(page.all('.contribution a.image').length).to eq(1)
    end
  end

  describe 'editing contributions', js: true do
    let!(:user) { create :user }
    let!(:contribution) { create :contribution, :user => user, :state => nil }

    before do
      login user
    end

    context 'a logged-in user' do
      it 'should be able to edit contributions they have created' do
        visit user_path(user)

        click_on "Edit Contribution"

        find(:css, '.contribution_body textarea').text "New test"
        click_on 'Record your contribution'

        should have_content 'Contribution updated successfully!'
      end

      it 'can delete a contribution' do
        visit user_path(user)

        accept_confirm do
          click_on "Remove Contribution"
        end

        should have_content "Contribution removed successfully!"
      end

      it "should not be able to edit other user's contributions" do
        contribution.user_id = nil
        contribution.save
        visit edit_contribution_path(contribution)

        should have_content 'You can only edit contributions that you have created'
      end
    end
  end
  
  describe 'deleting the only manual contribution', js: true do
    let!(:user) { create :user }
    let!(:contribution) { create :contribution, :user => user, :state => nil }
    
    before do
      login user
      # Ensure this is the only contribution
      expect(user.contributions.count).to eq(1)
    end
    
    it 'can view profile page after deleting manual contribution' do
      # Delete the contribution
      visit user_path(user)
      
      accept_confirm do
        click_on "Remove Contribution"
      end
      
      should have_content "Contribution removed successfully!"
      
      # Visit the profile page again - this should not cause a 500 error
      visit user_path(user)
      
      # Check that we're on the profile page and it loaded properly
      should have_content user.nickname
      should_not have_content 'Edit Contribution'
      # Check that the contribution count is now 0
      should have_content "0 contributions"
    end
  end
end
