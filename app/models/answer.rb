class Answer < ApplicationRecord
  belongs_to :question

  validates :answer_content, presence: true

  scope :correct, -> { where(is_true_anwser: true) }
end
