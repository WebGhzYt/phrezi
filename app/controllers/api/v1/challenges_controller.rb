module Api
  module V1
    class ChallengesController < ApplicationController
      before_filter :authenticate_user!
      allow_oauth!
      
      def show
        @challenge = Challenge.where(id: params[:id]).first
        if @challenge.nil?
          render json: { faliure_message: "Invalid id" }
        else
          render json: @challenge, status: 200
        end
      end
    end
  end
end