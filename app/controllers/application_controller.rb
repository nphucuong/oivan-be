class ApplicationController < ActionController::API
  def authenticate_user!
    unless current_user
      render json: { error: 'Please login!' }, status: 401
    end
  end
end
