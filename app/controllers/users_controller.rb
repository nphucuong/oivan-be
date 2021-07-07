class UsersController < ApiController
  before_action :authenticate_user!, :teacher?
  before_action :find_user, only: %i[show update destroy]
  respond_to :json

  def index
    render_records(User.all)
  end

  def show
    render_record @user
  end

  def create
    return render_error_message('invalid role') unless valid_role?

    user = User.new(user_params)
    if user.valid?
      authenticable = params[:role].constantize.create
      user.authenticable = authenticable
      user.save
      render_record user
    else
      render_error_message(user.errors, 400)
    end
  end

  def update
    return render_error_message('invalid role') unless valid_role?

    @user.assign_attributes(user_params)
    if @user.valid?
      unless params[:role] == @user.authenticable_type
        @user.authenticable&.destroy
        authenticable = params[:role].constantize.create
        @user.authenticable = authenticable
      end

      @user.save
      render_record @user
    else
      render_error_message(@user.errors, 400)
    end
  end

  def destroy
    @user.destroy
    render_success_request
  end

  private

  def teacher?
    return render_error_message('Not teacher', 401) unless current_user.authenticable.is_a?(Teacher)
  end

  def user_params
    params.permit(:email, :password, :name)
  end

  def find_user
    @user = User.find_by(id: params[:id])
    return render_error_message('Not found user', 404) unless @user
  end

  def valid_role?
    User::AUTHENTICABLE_TYPE.values.include? params[:role]
  end
end
