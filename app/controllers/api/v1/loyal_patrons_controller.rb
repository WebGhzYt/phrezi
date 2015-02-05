module Api
  module V1
    class LoyalPatronsController < ApiController
      before_action :current_establishment
      def purchase_transaction
        #first find the active challenge
        #Loyal patron will purchase boosters of active challenge.
        #So boosters array will come in params and we will create multiple
        #booster transactions.
        #it means each purchase transaction have multiple booster transactions
        find_active_challenge
        params[:boosters_ids].split(",").each do |id|
          booster_transactions(id,params[:loyal_patron_id],params[:establishment_id])
        end
        
        purchase_transaction = PurchaseTransaction.new
        purchase_transaction.amount = params[:amount]
        purchase_transaction.loyal_patron_id = params[:loyal_patron_id]

        if purchase_transaction.save!
          render :json => {"status"=> 1 , "message" => "Purchase transaction is created successfully."}
        else
          render :json => {"status"=> 0 , "errors" => "#{purchase_transaction.errors.full_messages.join(',')}"}
        end
      end
      def booster_transactions(id,loyal_patron_id,establishment_id)
        #add establishment id and challenge id but first find active challaenge.
        booster_transaction = BoosterTransaction.new
        #booster_transaction.points_scored = params[:points_scored]
        booster_transaction.ballyhoo_id = id
        booster_transaction.challenge_id = @active_challenges.id 
        booster_transaction.loyal_patron_id = loyal_patron_id
        booster_transaction.loyal_patron_id = establishment_id
        booster_transaction.save!
      end
      def find_active_challenge
        @current_establishment.challenges.each do |challenge|
          if challenge.active?
            @active_challenges = challenge
          end
        end
      end
    end
  end
end