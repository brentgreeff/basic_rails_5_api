class GroupEventsController < ApplicationController
  before_action :load_event, only: [:update, :destroy]

  def index
    head :ok
  end

  def create
    @group_event = GroupEvent.create!(group_params)
    render json: @group_event, status: :created
  end

  def update
    @group_event.update!( group_params )
  end

  def destroy
    @group_event.destroy
  end

  private

  def group_params
    params.permit(
      :name, :description, :location, :published,
      :starting, :ending, :duration
    )
  end

  def load_event
    @group_event = GroupEvent.find params[:id]
  end
end
