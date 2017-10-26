require 'pry'
class EventsController < ApplicationController
  before_action :load_event, only: [:update, :destroy]

  def index
    render json: Event.all
  end

  def create
    @event = Event.create!(group_params)
    render json: @event, status: :created
  end

  def update
    @event.update!( group_params )
  end

  def destroy
    @event.destroy
  end

  private

  def group_params
    params.require(:event).permit(
      :name, :description, :location, :published,
      :starting, :ending, :duration, group_attributes: [
        :name,
        group_users_attributes: [:user_id]
      ]
    )
  end

  def load_event
    @event = Event.find params[:id]
  end
end
