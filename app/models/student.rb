class Student < ApplicationRecord
  has_one :user, as: :authenticable, dependent: :destroy
end
