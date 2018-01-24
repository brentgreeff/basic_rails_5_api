class AuthenticationsController < ApplicationController

  def create
    @user = User.find_by(email: params[:email])
    invalid_credentials if @user.nil?

    if @user.authenticate(params[:password])
      render json: {'auth_token' => auth_token}.to_json
    else
      invalid_credentials
    end
  end

  private

  def auth_token
    JWT.encode({
      user_id: @user.id,
      exp: 24.hours.from_now.to_i
      },
      Rails.application.secrets.secret_key_base
    )
  end

  def invalid_credentials
    raise AuthenticationError, 'Invalid credentials'
  end
end
