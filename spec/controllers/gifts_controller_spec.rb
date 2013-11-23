require 'spec_helper'

describe GiftsController do
  let(:user) { create(:user) }
  let(:gift) { create(:gift, :user => user) }

  describe 'DELETE destroy' do
    it "removes the gift" do
      session[:user_id] = user.id
      delete :destroy, :id => gift.date

      Gift.find_by(id: gift.id).should be_nil
    end
  end
end
