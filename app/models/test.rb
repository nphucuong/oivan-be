class Test < ApplicationRecord
  extend TestCreator

  has_many :questions
  has_many :correct_answers, -> { Answer.correct }, through: :questions, source: :answers

  validates :name, presence: true
end
