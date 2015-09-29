require 'rails_helper'

describe GiftsController, type: :controller do
  let(:user) { create(:user) }
  let(:gift) { create(:gift, user: user) }
  let!(:pull_requests) { 2.times.map { create :pull_request, user: user } }

  before do
    allow_any_instance_of(User).to receive(:admin?).and_return(true)
    session[:user_id] = user.id
  end

  describe 'DELETE destroy' do
    it 'removes the gift' do
      delete :destroy, id: gift.date

      expect(Gift.find_by(id: gift.id)).to be_nil
    end
  end

  describe 'GET new' do
    render_views

    it 'should pre-fill the date when one is passed' do
      get :new, date: '2015-12-03'
      expect(response.body).to match(/<option selected="selected" value="2015-12-03">/)
    end
  end
end
