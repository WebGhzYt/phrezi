module Api
  module V1
    class BallyhoosController < ApplicationController

    	before_action :set_ballyhoo, only: [:show, :edit, :update, :destroy]
  		before_action :set_ballyhoo_type

      before_filter :authenticate_user!
      allow_oauth!

      def show
        @user = current_user
        if @ballyhoo.process_for(@user)
        	'YUP'
      	else
      		'NOPE'
      	end
      end

      def process_ballyhoo
      	
      end

      def set_ballyhoo_type
		    @ballyhoo_type = ballyhoo_type
		  end

		  def ballyhoo_type
		    params[:type] || "Ballyhoo"
		  end

		  def ballyhoo_type_class
		    ballyhoo_type.constantize
		  end

		  def set_ballyhoo
		    @ballyhoo = ballyhoo_type_class.find(params[:id])
		  end
      
    end
  end
end