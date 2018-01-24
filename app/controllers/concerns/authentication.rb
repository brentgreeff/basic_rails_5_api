module Authentication
  extend ActiveSupport::Concern

  included do

    rescue_from AuthenticationError do |e|
      message = { message: e.message }
      render json: message, status: :unauthorized
    end

    attr_reader :current_user

    def load_current_user
      raise AuthenticationError, 'Token required' if auth_header.blank?
      @current_user = User.find( get_user_id )
    rescue JWT::DecodeError => e
      raise AuthenticationError, 'Invalid token'
    end

    private

    def get_user_id
      JWT.decode(auth_header, secret_key)[0]['user_id']
    end

    def auth_header
      request.headers['Authorization']
    end

    def secret_key
      Rails.application.secrets.secret_key_base
    end
  end
end
