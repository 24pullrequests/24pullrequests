class OrganisationsController < ApplicationController
  # before_action :ensure_logged_in, only: [ :projects ]

  respond_to :html, :json
  # respond_to :js, only: :index

  def index
    @organisations = Organisation.order('random()').includes(:users).page params[:page]
    respond_with @organisations
  end

  def show
    @organisation = Organisation.find_by_login!(params[:id])
    respond_with @organisation
  end
end
