module V1
  class RouteErrorsController < ApplicationController
    def error_404
      render json: {errors: [{status: :not_found, message: "404: Not found."}]}, status: :not_found
    end
  end
end
