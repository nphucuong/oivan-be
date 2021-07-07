class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  AUTHENTICABLE_TYPE = {
    TEACHER: 'Teacher',
    STUDENT: 'Student'
  }.freeze

  belongs_to :authenticable, polymorphic: true, optional: true

  validates :email, :name, presence: true
  validates :email, uniqueness: { case_sensitive: false }
end
