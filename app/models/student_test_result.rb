class StudentTestResult < ApplicationRecord
  belongs_to :test
  belongs_to :student

  before_create :calculate_score

  private

  def calculate_score
    correct_answers = test.correct_answers
    number_questions = test.questions.count
    raise StandardError, 'miss number of correct answers' unless correct_answers.count == number_questions

    # a = [1, 2, 3]
    # b = [1, 4, 3]
    # a.zip(b).map { |x, y| x == y } # [true, false, true]

    correct_answer_ids = correct_answers.pluck(:id)
    matched_correct_answers = correct_answer_ids.zip(result).map do |correct_answer, student_answer|
      correct_answer == student_answer
    end

    self.score = matched_correct_answers.count(true).to_f / number_questions * 10
  end
end
