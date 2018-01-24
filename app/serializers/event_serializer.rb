class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :location, :starting, :ending, :published,
    :duration, :created_at, :updated_at, :deleted_at,
    :description

  belongs_to :group
  belongs_to :organiser
end
