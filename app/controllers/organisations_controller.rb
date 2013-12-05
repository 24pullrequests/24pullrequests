class OrganisationsController < ApplicationController

  respond_to :html, :json
  respond_to :js, only: :index

  def index
    @organisations = Organisation.order('pull_requests_count desc').includes(:users).page params[:page]
    respond_with @organisations
  end

  def show
    @organisation = Organisation.find_by_login!(params[:id])
    respond_with @organisation
  end
end
