class TestsController < ApiController
  before_action :authenticate_user!
  before_action :find_test, :teacher?, only: %i[show update destroy]
  respond_to :json

  def index
    render_records Test.all
  end

  def show
    render_record @test
  end

  def create
    test = Test.create_test(params)
    if test.present?
      render json: test
    else
      render_bad_request
    end
  end

  def update; end

  def destroy
    @test.destroy
    render render json: { success: true }
  end

  private

  def teacher?
    return render_error_message('Not teacher', 401) unless current_user.authenticable.is_a?(Teacher)
  end

  def find_test
    @test = Test.find_by(id: params[:id])
    return render_error_message('Not found user', 404) unless @test
  end
end
