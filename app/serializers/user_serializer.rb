class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :role

  def role
    object.authenticable_type
  end
end
