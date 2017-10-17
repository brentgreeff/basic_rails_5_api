module RecordInvalidHandler
  extend ActiveSupport::Concern

  included do

    rescue_from ActiveRecord::RecordInvalid do |e|
      message = { message: e.message }
      render json: message, status: :unprocessable_entity
    end
  end
end
