module Api
  module V1
    class ApiController < ApplicationController
      def current_establishment
        @current_establishment = Establishment.find(params[:establishment_id])
      end
    end
  end
end