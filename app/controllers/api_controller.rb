class ApiController < ApplicationController
  def render_records(records)
    render(
      json: records,
      root: 'records'
    )
  end

  def render_record(record, optional = {})
    render(
      json: record,
      root: 'record',
      meta: true,
      meta_key: 'success',
      optional: optional
    )
  end

  def render_error_message(message, code = 403)
    render json: { error_message: message, success: false }, status: code
  end

  def render_bad_request
    render json: { success: false }, status: 400
  end

  def render_success_request
    render json: { success: true }, status: 200
  end
end
