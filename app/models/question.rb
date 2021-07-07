class Question < ApplicationRecord
  has_many :answers

  belongs_to :test

  validates :label, :question_content, presence: true
end
