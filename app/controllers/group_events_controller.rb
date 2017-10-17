class GroupEventsController < ApplicationController

  def index
    head :ok
  end

  def create
    @group_event = GroupEvent.create!(group_params)
    render json: @group_event, status: :created
  end

  def update

  end

  private

  def group_params
    params.permit(
      :name, :description, :location, :published,
      :starting, :ending, :duration
    )
  end
end
