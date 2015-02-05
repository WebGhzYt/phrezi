module Api
  module V1
    class EnrolledChallengesController < ApplicationController

      before_filter :authenticate_user!
      allow_oauth!

      def index
        @user = current_user
        @enrolled_challenges = @current_user.enrolled_challenges
        render json: @enrolled_challenges
      end

      def show
        @user = current_user
        @enrolled_challenge = @current_user.enrolled_challenges.find(params[:id])
        render json: @enrolled_challenge
      end
      
    end
  end
end