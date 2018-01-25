class Group < ApplicationRecord

  validates :name, presence: true

  has_many :group_users
  accepts_nested_attributes_for :group_users

  has_many :guests, through: 'group_users', source: 'user'
end
