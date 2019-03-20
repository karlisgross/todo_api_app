module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError do |e|
      respond("A problem ocurred.", :internal_server_error)
    end

    rescue_from ActionController::RoutingError do |e|
      respond(e.message, :not_found)
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      respond(e.message, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      respond(e.message, :unprocessable_entity)
    end

    rescue_from ActiveRecord::RecordNotUnique do |e|
      respond("Record not unique.", :unprocessable_entity)
    end

    rescue_from ActiveRecord::RecordNotSaved do |e|
      respond(e.message, :bad_request)
    end

    rescue_from ActiveRecord::RecordNotDestroyed do |e|
      respond(e.message, :bad_request)
    end
  end

  private

  def respond(message, status)
    render json: {errors: [{status: status, message: message}]}, status: status
  end

end
