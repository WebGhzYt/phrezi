module Api
  module V1
    class BoostersController < ApplicationController
      before_action :current_establishment , :only => [:current_boosters]
      
      def current_boosters
        active_ballyhoos = []
        @current_establishment.ballyhoos.each do |ballyhoo|
          if ballyhoo.active?
            active_ballyhoos << ballyhoo
          end
        end
        render :json => {"status" => 1 , "active_boosters" => active_ballyhoos}
      end
      
      def get_booster
        booster = Ballyhoo.find(params[:id])
        render :json => {"status" => 1, "booster"=> booster}
      end
      
    end
  end
end