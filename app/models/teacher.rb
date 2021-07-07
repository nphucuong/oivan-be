class Teacher < ApplicationRecord
  has_one :user, as: :authenticable, dependent: :destroy
end
