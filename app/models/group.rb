class Group < ApplicationRecord

  validates :name, presence: true

  has_many :group_users
  accepts_nested_attributes_for :group_users
end
