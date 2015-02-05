module Api
  module Pos
    class PosController < ApplicationController
      before_filter :authenticate_user!
      allow_oauth!
      
      def current_establishment
        get_current_establishment
        render json: @establishment, each_serializer: EstablishmentPosSerializer
      end
      helper_method :current_establishment

      def current_establishment=(establishment)
        session[:pos_establishment_id] = establishment.id
        @current_establishment = establishment
      end

      def set_current_establishment
        if current_user.has_establishment_access?
          establishments = Establishment.all
        else
          establishments = current_user.establishments
        end
        set_establishment = establishments.where(id: params[:establishment_id]).first
        if set_establishment.nil?
          render json: { faliure_message: "That is an invalid establishment" }
        else
          self.current_establishment = set_establishment
          render json: set_establishment, each_serializer: EstablishmentPosSerializer 
        end
      end

      def patron_listing
        get_current_establishment
        if get_current_establishment.nil?
          render json:  {failure_message: "establishment not found"}
        else
          checkins = Checkin.where(establishment_id: @establishment.id, end_time: nil)
          @patron = []
          checkins.each do |checkin|
            @patron <<
            {
              id: checkin.user.id,
              first_name: checkin.user.name,
              last_name: checkin.user.last_name,
            }
          end
          render json: { patrons: @patron }
        end
      end

      def patron_detail
        get_current_establishment
        if get_current_establishment.nil?
          render json:  {failure_message: "establishment not found"}
        else
          checkins = Checkin.where(establishment_id: @establishment.id, end_time: nil)
          patron = checkins.where(user_id: params[:id]).first
          if patron.nil?
            render json: { faliure_message: "The user does not exist" }
          else
            @establishment.challenges.each do |challenge|
              if challenge.active?
                @active_challenge = challenge
              end
            end
            unless @active_challenge.nil?
              enrolled_challenge = EnrolledChallenge.where(challenge_id: @active_challenge.id, patron_id: params[:id]).first
              if enrolled_challenge.nil?
                credit_available =  0
              else
                credit_available = enrolled_challenge.current_points
              end
            else
              0
            end
            @patron =
              {
                first_name: patron.user.name,
                last_name: patron.user.last_name,
                email_address: patron.user.email,
                id: patron.user.id,
                credit_available: credit_available
              }
            render json: { patron: @patron }
          end
        end
      end

      def patron_cart_update
        get_current_establishment
        if get_current_establishment.nil?
          render json:  {failure_message: "establishment not found"}
        else
          @patron_cart = PatronCart.where(loyal_patron_id: params[:id], establishment_id: @establishment.id).first
          if @patron_cart.nil?
            @patron_cart = PatronCart.new
            @patron_cart.loyal_patron_id = params[:id]
            if params[:cart][:total].nil?
              @patron_cart.purchase_total = 0
            else
              @patron_cart.purchase_total = params[:cart][:total]
            end
            @patron_cart.establishment_id = @establishment.id
            @patron_cart.save!
          else
            if params[:cart][:total].nil?
              @patron_cart.purchase_total = 0
            else
              @patron_cart.purchase_total = params[:cart][:total]
            end
            @patron_cart.save!
          end
          if params[:cart][:boosters].nil?
            @points = @patron_cart.purchase_total
          else
            @points = @patron_cart.purchase_total
            @cart_boosters = []
            params[:cart][:boosters].each do |data| 
              @cart_booster = CartBooster.new
              @cart_booster.patron_cart_id = @patron_cart.id
              @cart_booster.booster_id = data[:id]
              @cart_booster.quantity = data[:quantity]
              @cart_booster.save!
              if @cart_booster.boosters.point_multiplier.nil? && @cart_booster.boosters.point_addition.nil?
                @booster_points = @cart_booster.boosters.point_value
                @points = @points + (@booster_points*@cart_booster.try(:quantity))
              else
                if @cart_booster.boosters.point_multiplier.nil?
                  @booster_points = @cart_booster.boosters.point_addition
                  @points = @points + (@booster_points*@cart_booster.try(:quantity))
                else
                  if @cart_booster.boosters.point_multiplier == 0
                    @booster_points = "Double"
                    @product = MenuItem.where(id: @cart_booster.boosters.product_category).first
                    if @product.nil?
                      @price = 0
                    else
                      @price = @product.price
                    end
                    @points = @points + (@price*@cart_booster.try(:quantity))
                  elsif @cart_booster.boosters.point_multiplier == 1
                    @booster_points = "Triple"
                    @points = @points + (@price*2*@cart_booster.try(:quantity))
                  else
                    # do nothing
                  end
                end
              end
              @cart_boosters << {
                id: @cart_booster.boosters.id,
                title: @cart_booster.boosters.title,
                points: @booster_points,
                quantity: @cart_booster.quantity
              }
            end
          end
          render json: { cart: {points: @points, total: @patron_cart.purchase_total, boosters: @cart_boosters}}
        end
      end

      def patron_cart_show
        get_current_establishment
        if get_current_establishment.nil?
          render json:  {failure_message: "establishment not found"}
        else
          @patron_cart = PatronCart.where(loyal_patron_id: params[:id], establishment_id: @establishment.id).first
          if @patron_cart.nil?
            render json: {failure_message: "Invalid patron"}
          else
            @points =  @patron_cart.purchase_total
            @cart_details = []
            @patron_cart.cart_boosters.each do |cart|
              if cart.boosters.point_multiplier.nil? && cart.boosters.point_addition.nil?
                @booster_points = cart.boosters.point_value
                @points = @points + (@booster_points*cart.try(:quantity))
              else
                if cart.boosters.point_multiplier.nil?
                  @booster_points = cart.boosters.point_addition
                  @points = @points + (@booster_points*cart.try(:quantity))
                else
                  if cart.boosters.point_multiplier == 0
                    @booster_points = "Double"
                    @product = MenuItem.where(id: cart.boosters.product_category).first
                    if @product.nil?
                      @price = 0
                    else
                      @price = @product.price
                    end
                    @points = @points + (@price*cart.try(:quantity))
                  elsif cart.boosters.point_multiplier == 1
                    @booster_points = "Triple"
                    @points = @points + (@price*2*cart.try(:quantity))
                  else
                    # do nothing
                  end
                end
              end
              @cart_details <<
              {
                id: cart.boosters.id,
                title: cart.boosters.title,
                points: @booster_points,
                quantity: cart.quantity
              }
            end
            render json: { cart: {points: @points, total: @patron_cart.purchase_total, boosters: @cart_details.uniq }}
          end
        end
      end

      def cart_process
        get_current_establishment
        if get_current_establishment.nil?
          render json:  {failure_message: "establishment not found"}
        else
          active_challenge = @establishment.challenges.select { |e|  e.active?  }.first
          @patron_cart = PatronCart.where(loyal_patron_id: params[:id], establishment_id: @establishment.id).first
          @enrolled_challenge = EnrolledChallenge.where(patron_id: params[:id], challenge_id: active_challenge.id).first
          if @patron_cart.present?
            @points = @patron_cart.purchase_total
            @patron_cart.cart_boosters.each do |cart|
              if cart.boosters.point_multiplier.nil? && cart.boosters.point_addition.nil?
                @booster_points = cart.boosters.point_value
                @points = @points + (@booster_points*cart.try(:quantity))
              else
                if cart.boosters.point_multiplier.nil?
                  @booster_points = cart.boosters.point_addition
                  @points = @points + (@booster_points*cart.try(:quantity))
                else
                  if cart.boosters.point_multiplier == 0
                    @booster_points = "Double"
                    @product = MenuItem.where(id: cart.boosters.product_category).first
                    if @product.nil?
                      @price = 0
                    else
                      @price = @product.price
                    end
                    @points = @points + (@price*cart.try(:quantity))
                  elsif cart.boosters.point_multiplier == 1
                    @booster_points = "Triple"
                    @points = @points + (@price*2*cart.try(:quantity))
                  else
                    # do nothing
                  end
                end
              end
            end
            gross_sales = active_challenge.gross_sales
            unless active_challenge.nil?
              if @enrolled_challenge.nil?
                @enrolled_challenge = EnrolledChallenge.new
                @enrolled_challenge.patron_id = params[:id]
                @enrolled_challenge.challenge_id = active_challenge.id
                @enrolled_challenge.current_points = @points
                @enrolled_challenge.save!
                active_challenge.gross_sales = gross_sales + @patron_cart.purchase_total
                active_challenge.participants = active_challenge.enrolled_challenges.count
                active_challenge.save!
                @patron_cart.destroy
              else
                @enrolled_challenge.current_points = (@enrolled_challenge.try(:current_points).try(:to_d) || 0) + @points
                @enrolled_challenge.save!
                active_challenge.gross_sales = gross_sales + @patron_cart.purchase_total
                active_challenge.participants = active_challenge.try(:enrolled_challenges).try(:count)
                active_challenge.save!
                @patron_cart.destroy
              end
            else
              render json: {failure_message: "Unable to redeem points. No active challenge found."}
            end
            render json: { message: "Cart Processed"}
          else
            render json: { failure_message: "There was an error"}
          end
        end
      end

      def cart_reset
        @patron_cart = PatronCart.where(loyal_patron_id: params[:id]).first
        if @patron_cart.nil?
          render json: { failure_message: "There was an error" }
        else
          @patron_cart.destroy
          render json: { message: "Cart Cleared" }
        end
      end

      def my_establishments
        if current_user.has_establishment_access?
          @establishments = Establishment.all
        else
          @establishments = current_user.establishments
        end
        render json: @establishments, each_serializer: EstablishmentSummarySerializer
      end

      private
      def get_current_establishment
        if session[:pos_establishment_id]
          if current_user.has_establishment_access?
            @establishment = Establishment.find(session[:pos_establishment_id])
          else
            @establishment = current_user.establishments.find_by(id: session[:pos_establishment_id])
          end
          return @establishment if @establishment.present?
        end
        if current_user.has_establishment_access?
          @establishment = Establishment.first
        else
          @establishment = current_user.establishments.first
        end
      end
    end
  end
end