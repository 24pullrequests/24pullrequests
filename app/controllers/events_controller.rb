class EventsController < ApplicationController
  before_action :ensure_logged_in, except: [:index, :show]

  def index
    @upcoming_events = Event.where(['start_time >= ?', Time.zone.today]).order('start_time')
    @past_events = Event.where(['start_time < ?', Time.zone.today]).order('start_time DESC')
  end

  def show
    @event = Event.find(params[:id])
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
    @event = current_user.events.find(params[:id])
  end

  def destroy
    @event = current_user.events.find(params[:id])
    @event.destroy!
    redirect_to events_path, notice: t('events.notice.destroy_success')
  end

  def update
    @event = current_user.events.find(params[:id])
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

  def object_name
    Event.find(params[:id]).name rescue nil
  end
end
