class EventsController < ApplicationController
  before_action :set_event, only: [ :show, :edit, :update, :destroy ]

  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
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

    redirect_to :back, notice: "Event has been removed"
  end

  def update
    if @event.update_attributes(event_params)
      redirect_to @event, notice: "Event updated successfully!"
    else
      render :edit
    end
  end

  protected

  def event_params
    params.require(:event).permit(:organiser, :location, :url, :start_time, :description)
  end

  def set_event
    @event = Event.find_by_id(params[:id])
  end
end
