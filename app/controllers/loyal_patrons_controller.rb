class LoyalPatronsController < WebApplicationController
  before_action :set_loyal_patron, only: [:show, :edit, :update, :destroy]
  def show
    
  end
  private
  def set_loyal_patron
    @loyal_patron = LoyalPatron.find(params[:id])
    current_establishment.challenges.each do |challenge|
      if challenge.active?
        @active_challenges = challenge
      end
    end
  end
end
