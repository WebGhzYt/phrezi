module Api
  module V1
    class UsersController < ApplicationController

      before_filter :authenticate_user!, except: [ :create ]
      allow_oauth! :except => :delete

      def show
      	@user = current_user if params[:id] == 'me'
        @user ||= User.find(params[:id])
        render json: @user
      end

      def update
        current_user.update(user_params)
        render json: current_user
      end

      def create
        user = User.find_by_email(user_signup_params[:email])

        if user
          render json: {
            failure_message: "This user already exists"
          }, status: 422
        else
          user = User.new(user_signup_params)
          if user.valid_password?(user_signup_params[:password])
            user.save
            render json: {
              message: "Please check your email to confirm registration"
              }, status: 200
          else
            render json: {
              failure_message: "Please try another password"
            }, status: 422
          end
        end
      end

      def me
        @user = current_user
        if @user
          render json: @user, status: 200
        else
          render json: {
            failure_message: "You are not signed in"
          }, status: 422
        end
      end

      def my_status
        @checkin = Checkin.where(user_id: current_user.id, end_time: nil)
        @establishment = []
        if @checkin
          @checkin.each do |check|
            @establishment << check.establishment
          end
          render json: { checkedin: true, establishment: @establishment.as_json }, status: 200
        else
          render json: {
            failure_message: "You're not logged in"
          }, status: 422
        end
      end

      def mycart
        @patron_cart = PatronCart.where(loyal_patron_id: current_user.id).first
        if @patron_cart.nil?
          render json: {failure_message: "No cart found"}
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
          render json: { cart: { points: @points, total: @patron_cart.purchase_total, boosters: @cart_details.uniq }}
        end
      end

      def user_params
        params.require(:user).permit(:name, :email)
      end

      def user_signup_params
        params.require(:user).permit(:name, :last_name, :email, :password, :password_confirmation)
      end 
    end
  end
end