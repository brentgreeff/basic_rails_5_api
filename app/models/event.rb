class Event < ApplicationRecord

  acts_as_paranoid

  belongs_to :organiser, class_name: 'User'

  belongs_to :group
  accepts_nested_attributes_for :group

  delegate :guests, to: :group

  allows :update,
    if: -> (event, user) do
      event.organiser == user || event.guests.include?( user )
    end

  before_validation :calc_duration, if: :has_dates?

  validates :name, :location, :starting, :ending, :description,
    presence: true, if: :published?

  private

  def calc_duration
    self.duration = (ending - starting) + 1
  end

  def has_dates?
    starting && ending
  end
end
