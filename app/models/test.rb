class Test < ApplicationRecord
  extend TestCreator

  has_many :questions

  validates :name, presence: true
end
