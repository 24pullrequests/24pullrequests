class EventsController < ApplicationController
  before_action :validate_current_user_exists, only: [ :edit, :new ]
  before_action :set_event, only: [ :show, :edit, :update, :destroy ]

  def index
    @events = Event.where(["start_time >= ?", Date.today]).order("start_time")
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.user_id = current_user.id
    if @event.save
      redirect_to @event
    else
      render :new
    end
  end

  def edit
  end

  def destroy
    @event.destroy!

    redirect_to :back, notice: t("events.notice.new_success")
  end

  def update
    if @event.update_attributes(event_params)
      redirect_to @event, notice: t("events.notice.edit_success")
    else
      render :edit
    end
  end

  protected

  def event_params
    params.require(:event).permit(:organiser, :location, :url, :start_time, :description, :latitude, :longitude)
  end

  def validate_current_user_exists
    redirect_to events_path, notice: t("events.notice.not_logged_in") unless current_user.present?
  end

  def set_event
    @event = current_user.events.find(params[:id])
    redirect_to events_path, notice: t("events.notice.not_authorized") if @event.nil?
  end
end
