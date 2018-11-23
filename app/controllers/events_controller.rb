class EventsController < ApplicationController
  before_action :ensure_logged_in, only: [:edit, :new]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @upcoming_events = Event.where(['start_time >= ?', Time.zone.today]).order('start_time')
    @past_events = Event.where(['start_time < ?', Time.zone.today]).order('start_time DESC')
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
    redirect_to events_path, notice: t('events.notice.destroy_success')
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: t('events.notice.edit_success')
    else
      render :edit
    end
  end

  protected

  def event_params
    params.require(:event).permit(:name, :location, :url, :start_time, :description, :latitude, :longitude)
  end

  def set_event
    @event = Event.find(params[:id])
    redirect_to events_path, notice: t('events.notice.not_authorized') if @event.nil?
  end
end
