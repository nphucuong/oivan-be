module TestCreator
  extend ActiveSupport::Concern

  def create_test(params)
    test = create_test_with_params(params)
    create_questions(params[:questions], test)
    test
  end

  def create_questions(questions_params, test)
    questions_params.each do |question_params|
      question = create_question_with_params(question_params, test.id)
      create_list_anwsers(question_params[:anwsers], question)
    end
  end

  def create_list_anwsers(params, question_id)
    Answer.create(answer_content: params[:answer_content],
                  is_true_anwser: params[:is_true_anwser],
                  question_id: question_id)
  end

  def create_test_with_params(params)
    Test.create(params[:name], params[:description])
  end

  def create_question_with_params(params, test_id)
    Question.create(label: params[:label],
                    question_content: params[:question_content],
                    test_id: test_id)
  end
end
