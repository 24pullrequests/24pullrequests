require 'spec_helper'

describe GiftsController do
  let(:user) { create(:user) }
  let(:gift) { create(:gift, :user => user) }

  before do
    session[:user_id] = user.id
  end


  describe 'DELETE destroy' do
    it "removes the gift" do
      delete :destroy, :id => gift.date

      Gift.find_by(id: gift.id).should be_nil
    end
  end

  describe 'GET new' do
    render_views

    it "should pre-fill the date when one is passed" do
      get :new, :date => '2013-12-03'
      expect(response.body).to match /<option selected="selected" value="2013-12-03">/
    end
  end
end
