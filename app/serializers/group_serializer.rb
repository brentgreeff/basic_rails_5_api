class GroupSerializer < ActiveModel::Serializer
  attributes :name

  has_many :group_users
end
