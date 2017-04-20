class EventsController < ApplicationController
  before_action :set_event, only: [:edit, :update, :destroy]

  def index
    skip_authorization
    @events = Event.all
  end

  def new
    @event = Event.new
    authorize @event
  end

  def create
    @event = Event.new(event_params)
    authorize @event
    if params[:image]
      @event.pictures.new(image: params[:image])
    end

    if @event.save
      flash[:notice] = 'Agendapunt is toegevoegd.'
      redirect_to events_path
    else
      flash.now[:alert] = 'Agendapunt is niet toegevoegd.'
      render 'new'
    end
  end

  def edit
    authorize @event
  end

  def update
    authorize @event
    if params[:image]
      @event.pictures.delete_all
      @event.pictures.new(image: params[:image])
    end

    if @event.update(event_params)
      flash[:notice] = 'Agendapunt is bijgewerkt.'
      redirect_to events_path
    else
      flash.now[:alert] = 'Agendapunt is niet bijgewerkt.'
      render 'edit'
    end
  end

  def destroy
    authorize @event
    @event.destroy
    flash[:notice] = 'Agendapunt is verwijderd.'

    redirect_to events_path
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :date)
  end

  def set_event
    @event = Event.find(params[:id])
  end
end
