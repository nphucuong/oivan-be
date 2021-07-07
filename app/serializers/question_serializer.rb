class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :label, :question_content

  has_many :answers
end
