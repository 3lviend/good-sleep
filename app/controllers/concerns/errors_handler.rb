module ErrorsHandler
  extend ActiveSupport::Concern

  included do
    # Handling error record not found
    rescue_from ActiveRecord::RecordNotFound do |e|
      log_error(e)
      respond_with_error(404, "Record not found", public_file: "404")
    end

    # Handling argument error
    rescue_from ArgumentError do |e|
      log_error(e)
      respond_with_error(422, e.message)
    end

    # Handling error no route match
    rescue_from ActionController::RoutingError do |e|
      log_error(e)
      respond_with_error(404, "Page not found!", public_file: "404")
    end

    # Handling error bad request parameters
    rescue_from ActionController::BadRequest do |e|
      log_error(e)
      respond_with_error(404, "Page not found!", public_file: "404")
    end

    # Handling error missing parameters
    rescue_from ActionController::ParameterMissing do |e|
      log_error(e)
      respond_with_error(422, "Internal Server Error")
    end

    # Handling error unknown format request
    rescue_from ActionController::UnknownFormat do |e|
      log_error(e)
      respond_with_error(422, "Requested format is not supported")
    end

    # Handling error unknown format parameter request
    rescue_from ActionDispatch::Http::Parameters::ParseError do |e|
      log_error(e)
      respond_with_error(400, "Bad Request: check your request body for errors")
    end

    rescue_from NotImplementedError do |e|
      log_error(e)
      respond_with_error(422, "Requested format is not supported")
    end

    rescue_from ActionController::UnpermittedParameters do |e|
      log_error(e)
      respond_with_error(422, "Bad Request: your request was rejected due to invalid or unauthorized fields")
    end
  end

  private

  def log_error(exception)
    logger.error(exception.message)
    logger.error(exception.backtrace.join("\n"))
  end

  def respond_with_error(status, message, public_file: nil)
    respond_to do |format|
      format.json { render json: { message: message }, status: status }
      format.any { head status } # For other formats, just return the status code
    end
  end
end
