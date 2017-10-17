class GroupEvent < ApplicationRecord

  before_validation :calc_duration

  private

  def calc_duration
    self.duration = ending - starting
  end
end
