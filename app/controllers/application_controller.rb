AuthenticationError = Class.new(StandardError)

class ApplicationController < ActionController::API
  include RecordInvalidHandler
  include RecordNotFoundHandler
  include Authentication
end
