class ApplicationController < ActionController::API

  include RecordInvalidHandler
  include RecordNotFoundHandler
end
