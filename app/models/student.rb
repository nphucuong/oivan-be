class Student < ApplicationRecord
  has_one :user, as: :authenticable, dependent: :destroy
  has_many :student_test_results
end
