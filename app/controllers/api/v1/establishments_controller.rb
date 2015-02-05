module Api
  module V1
    class EstablishmentsController < ApplicationController

      before_filter :authenticate_user!
      allow_oauth!

      def index
      	render json: Establishment.all, each_serializer: EstablishmentSummarySerializer
      end

      def show
        @establishment =  Establishment.where(id: params[:id]).first
        if @establishment.nil?
          render json: {failure_message: "Invalid id"}
        else
          render json: @establishment, serializer: EstablishmentSerializer
        end
      end

      def near
        if params[:gps_lat].blank? or params[:gps_long].blank?
          render json: { failure_message: "Invalid parameters" }
        else
          render json: Establishment.near([params[:gps_lat], params[:gps_long]], params[:radius] || 1000), each_serializer: EstablishmentSummarySerializer
        end
      end

      def within_box
        if params[:SW_lat].blank? or params[:SW_long].blank? or params[:NE_lat].blank? or params[:NE_long].blank?
          render json: { success: false, message: "Invalid parameters" }
        else
          @sw = Geokit::LatLng.new(params[:SW_lat], params[:SW_long])
          @ne = Geokit::LatLng.new(params[:NE_lat], params[:NE_long])
          render json: Establishment.in_bounds([@sw, @ne]).all, each_serializer: EstablishmentSummarySerializer
          # bounds = Geocoder::Calculations.geographic_center([[params[:SE_lat],params[:SE_long]], [params[:NW_lat], params[:NW_long]]])
          # render json: Establishment.within_bounding_box(Geocoder::Calculations.bounding_box(bounds, params[:dist] || 1000)), each_serializer: EstablishmentSummarySerializer
        end
      end

      def participating
        @establishments = []
        # active_challenge = current_establishment.challenges.select {|challenge| challenge.active? }
        # if active_challenge.empty?
        #   render json: {failure_message: "No Active challenge found"}
        # else
          enrolled_challenge = EnrolledChallenge.where(patron_id: current_user.id)
          if enrolled_challenge.empty?
            render json: {failure_message: "No establishments found."}, status: 422
          else
            enrolled_challenge.each do |challenge|
              challenge = Challenge.find(challenge.challenge.id)
              establishment = Establishment.where(id: challenge.establishment_id).first
              @establishments << establishment
            end
            render json: @establishments.uniq, :only => [:id, :name, :credit_available, :current_challenge, :num_boosters_today], each_serializer: EstablishmentSerializer
          end
        # end
      end

      def checkin
        @checkin = Checkin.where(user_id: current_user.id, end_time: nil).first
        @establishment = Establishment.where(:id => params[:id]).first
        
        if @establishment.nil?
          render json: {failure_message: "No establishment found."}, status: 422
        elsif @establishment.establishment_hours.where(day: Time.now.strftime("%A").camelize).first.closed? == false 
          render json: {failure_message: "Establishment closed"}
        else
          if @checkin.nil?
            @checkin = Checkin.new(:start_time => Time.now, :establishment_id => params[:id], :user_id => current_user.id)
            if @checkin.save
              active_challenge = @establishment.challenges.select {|challenge| challenge.active? }
              unless active_challenge.empty?
                active_ballyhoos = @establishment.checkin_ballyhoos.select { |checkin_ballyhoo| checkin_ballyhoo.active? }
                unless active_ballyhoos.empty?
                  active_ballyhoos.each do |active_ballyhoo|
                    booster_transaction = BoosterTransaction.create(:ballyhoo_id => active_ballyhoo.id,
                      :loyal_patron_id => current_user.id,
                      :points_scored => active_ballyhoo.point_value,
                      # :establishment_id => active_ballyhoo.establishment_id,
                      :challenge_id => active_challenge.first.id
                    )
                    enrolled_user = EnrolledChallenge.where(patron_id: current_user.id, :challenge_id => active_challenge.first.id).first
                    if enrolled_user.nil?
                      enrolled_points = EnrolledChallenge.create(:patron_id => current_user.id,
                                                                :current_points => active_ballyhoo.point_value,
                                                                :challenge_id => active_challenge.first.id)
                      active_challenge.first.participants = active_challenge.first.enrolled_challenges.count
                      active_challenge.first.save!
                    else
                      enrolled_user.update_attributes(current_points: enrolled_user.current_points + active_ballyhoo.point_value)
                      active_challenge.first.participants = active_challenge.first.enrolled_challenges.count
                      active_challenge.first.save!
                    end
                  end
                  render json: { checkin: true }, status: 200
                else
                  render json: { checkin: "successfully checkin. No active booster found" }, status: 200
                end
              else
                render json: { checkin: "successfully checkin. No active challenge found" }
              end
            end
          else
            render json: {failure_message: "Already checkin in some establishment. You only checkin once at a time."}, status: 422
          end
        end
      end

      def checkout
        @checkout = Checkin.where(user_id: current_user.id, establishment_id: params[:id], end_time: nil).first
        if @checkout.nil?
          render json: { failure_message: "You are not checked in" }
        else
          checkout = @checkout.update_attributes(end_time: Time.now)
          render json: { checkout: true }
        end
      end

      def mystatus
        @checkin = Checkin.where(user_id: current_user.id, establishment_id: params[:id], end_time: nil).first
        if @checkin
          render json: {
            status: "checkedin",
            checkin_time: @checkin.start_time.strftime("%d-%m-%Y,%H:%M")
          }
        else
          render json: {
            status: "checkedout"
          }
        end
      end

      def boosters
        @selected_date = params[:date].present? ? Date.parse(params[:date]) : Date.today
        all_boosters = Ballyhoo.all.where(establishment_id: params[:id])
        @list_of_boosters = []
        all_boosters.each do |boosters|
          if boosters.end_repeat.nil?
            if (boosters.start_date <= @selected_date)
              booster = Ballyhoo.find(boosters.id)
              if booster.point_multiplier == 0
                point_multiplier = "Double"
              elsif booster.point_multiplier == 1
                point_multiplier = "Triple"
              else
                # do nothing
              end
              if boosters.point_multiplier.nil? && !boosters.point_addition.nil?
                category = Category.where(id: boosters.product_category).first
                if category.nil?
                  product_category = 'Not Available'
                else
                  product_category = category.category
                end
              elsif !boosters.point_multiplier.nil? && boosters.point_addition.nil?
                product = MenuItem.where(id: boosters.product_category).first
                if product.nil?
                  product_category = 'Not Available'
                else
                  product_category = product.name
                end
              end
              @list_of_boosters << {
                title: booster.try(:title), 
                start_date: booster.try(:start_date),
                start_time: booster.try(:start_time).try(:in_time_zone, booster.establishment.timezone.to_i).try(:strftime, "%H:%M:%S"),
                end_time: booster.try(:end_time).try(:in_time_zone, booster.establishment.timezone.to_i).try(:strftime, "%H:%M:%S"),
                point_value: booster.try(:point_value),
                id: booster.try(:id),
                ballyhoo_type: booster.try(:ballyhoo_type),
                repeating_days: booster.try(:repeating_days),
                audience: booster.try(:audience),
                total_checkin_qty: booster.try(:total_checkin_qty),
                limit_person: booster.try(:limit_person),
                friends: booster.try(:friends),
                min_no_of_item: booster.try(:min_no_of_item),
                product_category: product_category,
                point_multiplier: point_multiplier,
                point_addition: booster.try(:point_addition)
              }
            end
          else
            if (boosters.start_date <= @selected_date) && (boosters.end_repeat >= @selected_date)
              booster = Ballyhoo.find(boosters.id)
              if booster.point_multiplier == 0
                point_multiplier = "Double"
              elsif booster.point_multiplier == 1
                point_multiplier = "Triple"
              else
                # do nothing
              end
              if boosters.point_multiplier.nil? && !boosters.point_addition.nil?
                category = Category.where(id: boosters.product_category).first
                if category.nil?
                  product_category = 'Not Available'
                else
                  product_category = category.category
                end
              elsif !boosters.point_multiplier.nil? && boosters.point_addition.nil?
                product = MenuItem.where(id: boosters.product_category).first
                if product.nil?
                  product_category = 'Not Available'
                else
                  product_category = product.name
                end
              end
              @list_of_boosters << {
                title: booster.try(:title), 
                start_date: booster.try(:start_date),
                start_time: booster.try(:start_time).try(:in_time_zone, booster.establishment.timezone.to_i).try(:strftime, "%H:%M:%S"),
                end_time: booster.try(:end_time).try(:in_time_zone, booster.establishment.timezone.to_i).try(:strftime, "%H:%M:%S"),
                point_value: booster.try(:point_value),
                id: booster.try(:id),
                ballyhoo_type: booster.try(:ballyhoo_type),
                repeating_days: booster.try(:repeating_days),
                audience: booster.try(:audience),
                total_checkin_qty: booster.try(:total_checkin_qty),
                limit_person: booster.try(:limit_person),
                friends: booster.try(:friends),
                min_no_of_item: booster.try(:min_no_of_item),
                product_category: product_category,
                point_multiplier: point_multiplier,
                point_addition: booster.try(:point_addition)
              }
            end
          end
        end
        render json: {
          boosters: @list_of_boosters
        }
      end
      
      def participating_patrons
        establishment =  Establishment.where(id: params[:id]).first
        if establishment.nil?
          render json: {failure_message: "Invalid id"}
        else
          active_challenge = establishment.challenges.select {|challenge| challenge.active? }.first
          if active_challenge.nil?
            render json: nil
          else
            @patron = []
            payout = active_challenge.calculate_current_payouts(active_challenge.participants.to_i)
            enrolled_challenge = EnrolledChallenge.where(challenge_id: active_challenge.id)
            enrolled_challenge.sort_by(&:current_points).reverse.each_with_index do |challenge, i|
              @patron <<
              {
                id: challenge.patron.id,
                name: challenge.patron.name,
                number_points: challenge.current_points,
                payout: payout[i].to_f
              }
            end
            render json: {
              patron: @patron
            }
          end
        end
      end
    end
  end
end