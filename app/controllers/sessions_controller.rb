class SessionsController < Devise::SessionsController
  # POST /users/sign_in 
  def create
    user = User.find_by(email: params[:email])

    if user.valid_password?(params[:password])
      token = user.generate_token
      refresh_token = user.generate_token(false)

      render json: { token: token, refresh_token: refresh_token }, status: :ok
    else
      render json: { error: I18n.t('invalid') }, status: :unprocessable_entity
    end
  end

  # GET /users/refresh_token
  def refresh_token
    refresh_token = request.headers['X-REFRESH-TOKEN']

    payload = decode_token(refresh_token)
    token = User.find_by(email: payload[:email]).generate_token
    render json: { msg: token }, status: :ok
  end
end
