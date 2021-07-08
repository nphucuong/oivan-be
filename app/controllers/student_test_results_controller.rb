class StudentTestResultsController < ApiController
  before_action :authenticate_user!
  before_action :student?, only: %i[create]
  respond_to :json

  def create
    result = StudentTestResult.create(result_params)
    if result
      render_success_request
    else
      render_bad_request
    end
  end

  private

  def result_params
    params.permit(:test_id, :student_id, result: [])
  end

  def student?
    return render_error_message('Not student', 401) unless current_user.authenticable.is_a?(Student)
  end
end
