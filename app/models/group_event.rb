class GroupEvent < ApplicationRecord

  acts_as_paranoid

  before_validation :calc_duration, if: :has_dates?

  validates :name, :location, :starting, :ending, :description,
    presence: true, if: :published?

  private

  def calc_duration
    self.duration = ending - starting
  end

  def has_dates?
    starting && ending
  end
end
