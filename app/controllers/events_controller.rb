class EventsController < ApplicationController
  before_action :load_current_user
  before_action :load_event, only: [:update, :destroy]

  def index
    render json: current_user.events
  end

  def create
    @event = current_user.events.create!(event_params)
    render json: @event, status: :created
  end

  def update
    @event.update!( event_params )
  end

  def destroy
    @event.destroy
  end

  private

  def event_params
    params.require(:event).permit(
      :name, :description, :location, :published,
      :starting, :ending, :duration, group_attributes: [
        :name,
        group_users_attributes: [:user_id]
      ]
    )
  end

  def load_event
    @event = current_user.events.find params[:id]
  end
end
