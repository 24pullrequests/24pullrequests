require 'spec_helper'

describe GiftsController do
  let(:user) { create(:user) }
  let(:gift) { create(:gift, :user => user) }

  describe 'GET index'
  describe 'POST create'
  describe 'GET new'
  describe 'GET edit'
  describe 'GET show'
  # ALSO: gift_params (calls pull_request_id, calls  post_params), gift_given, gift_failed,
  describe 'PUT/PATCH update'

  describe 'DELETE destroy' do
    it "removes the gift" do
      session[:user_id] = user.id
      delete :destroy, :id => gift.date

      Gift.find_by(id: gift.id).should be_nil
    end
  end
end
