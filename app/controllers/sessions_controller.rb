class SessionsController < Devise::SessionsController
  respond_to :json
  after_filter :auth_success_callback

  def auth_success_callback
    custom_resp_body = JSON.parse(response.body)
    custom_resp_body['authenticity_token'] = current_user.reset_password_token
    response.body = custom_resp_body.to_json
  end
end
