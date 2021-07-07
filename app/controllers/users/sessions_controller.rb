class Users::SessionsController < Devise::SessionsController
  before_action :authenticate_user!, except: [:create]

  respond_to :json

  def create
    resource = warden.authenticate!(scope: resource_name, recall: "#{controller_path}#new")
    resource['email'] = resource['email'].downcase
    sign_in(resource_name, resource)
    user = resource
    result = {
      "id": user.id,
      "email": user.email,
      "name": user.name
    }
    render json: result
  end

  private

  def respond_with(_resource, _opts = {})
    render json: { message: 'Please login first' }, status: 401
  end

  def respond_to_on_destroy
    render json: { success: true }
  end
end
