class User < ApplicationRecord

  has_secure_password

  validates :email, presence: true

  acts_as_human

  has_many :events, foreign_key: 'organiser_id'
end
