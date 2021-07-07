class Answer < ApplicationRecord
  belongs_to :question

  validates :answer_content, presence: true
end
