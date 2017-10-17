module RecordNotFoundHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      message = { message: e.message }
      render json: message, status: :not_found
    end
  end
end
