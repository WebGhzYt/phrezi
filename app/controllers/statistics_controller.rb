class StatisticsController < WebApplicationController
	skip_before_action :load_establishment

  def index
    @payouts ||= @payouts.to_a
  	@challenge = Challenge.new(start_date: Date.current, end_date: Date.current + 1.week, challenge_prize: 0.20, challenge_winner: 0.25, win_differential: 0.10)
  end

  def calculate
  	#@challenge = current_establishment.challenges.new(challenge_params)
    @challenge = Challenge.new
    @challenge.challenge_prize = challenge_params[:challenge_prize]
    @challenge.challenge_winner = challenge_params[:challenge_winner]
    @challenge.win_differential = challenge_params[:win_differential]
    @challenge.gross_sales = challenge_params[:gross_sales]
    puts "sales: #{@challenge.gross_sales} prize: #{@challenge.challenge_prize} challenge_winner: #{@challenge.challenge_winner} win_differential: #{@challenge.win_differential}\n"
  	@payouts = @challenge.calculate_current_payouts(params[:patrons].to_i)
    
  	render 'index'
  end

  private
  	def challenge_params
      params.require(:challenge).permit(:participants, :challenge_prize, :challenge_winner, :win_differential, :gross_sales)
    end
  	def participants_param

  	end
end
