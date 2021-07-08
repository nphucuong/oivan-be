module TestCreator
  extend ActiveSupport::Concern

  def create_test(params)
    test = create_test_with_params(params)
    create_questions(params[:questions], test)
    test
  end

  def update_test(params, test)
    destroy_questions(test)
    create_questions(params[:questions], test)
    test.update!(name: params[:name], description: params[:description])
    test.reload
  end

  def create_questions(questions_params, test)
    questions_params.each do |question_params|
      question = create_question_with_params(question_params, test.id)
      create_list_answers(question_params[:answers], question.id)
    end
  end

  def create_list_answers(answers_params, question_id)
    answers_params.each do |answer_params|
      Answer.create!(
        answer_content: answer_params[:answer_content],
        is_true_anwser: answer_params[:is_true_anwser],
        question_id: question_id
      )
    end
  end

  def create_test_with_params(params)
    Test.create!(name: params[:name], description: params[:description])
  end

  def create_question_with_params(params, test_id)
    Question.create!(
      label: params[:label],
      question_content: params[:question_content],
      test_id: test_id
    )
  end

  def destroy_questions(test)
    test.questions.each(&:destroy) # dependent: :destroy answers
  end
end
