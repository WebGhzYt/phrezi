class ChallengesController < WebApplicationController
  before_action :set_challenge, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  # before_action :set_ballyhoo, only: [:index]
  # before_action :set_ballyhoo_type

  def index
    populate_form
    @challenge_count = current_establishment.challenges.count
    @ballyhoo = ballyhoo_type_class.new
    @challenge_cost = @challenge.calculate_challenge_cost(@active_challenges)
    @employees = current_establishment.employees
    @menu_items = current_establishment.menu_items
    populate_loyal_patrons
    if @active_challenges.present?
      @edit_challenge = Challenge.find(@active_challenges.id)
      determine_payout
    end
  end

  def show
  end

  def edit
    populate_form(false)
    render 'index'
  end

  def create
    populate_form(false)
    @challenge = current_establishment.challenges.new(challenge_params)
    if @challenge.save
      challenge_count = current_establishment.challenges.count
      if challenge_count == 1
        @challenge.linked_with = nil
      end
      if @challenge.active?
        upcoming_challenge = current_establishment.challenges.new(challenge_params)
        start_date = @challenge.try(:start_date)
        end_date = @challenge.try(:end_date)
        difference = (end_date.to_date - start_date.to_date).to_i
        upcoming_challenge.start_date =  @challenge.end_date.strftime("%Y-%m-%d").to_date + 1.day
        upcoming_challenge.end_date = @challenge.end_date.strftime("%Y-%m-%d").to_date + (difference +1).day
        upcoming_challenge.linked_with = @challenge.id
        upcoming_challenge.save
      end
      if challenge_count == 1
        render :js => "document.location = '/challenges?active=true&first=true'"
      else
        render :js => "document.location = '/challenges?active=true&first=false'"
      end
    else
      @challenge_count = current_establishment.challenges.count
      @ballyhoo = ballyhoo_type_class.new
      respond_to do |format|
        format.js {render "/layouts/errors", locals: { full_errors: @challenge.errors.full_messages }}
      end
    end
  end

  def update
    @edit_challenge = Challenge.find(params[:id])
    if @edit_challenge.update(challenge_params)
      @upcoming_challenge = Challenge.where(linked_with: @edit_challenge.id).first
      unless @upcoming_challenge.nil?
        @upcoming_challenge.update(challenge_params)
        start_date = @edit_challenge.try(:start_date)
        end_date = @edit_challenge.try(:end_date)
        difference = (end_date.to_date - start_date.to_date).to_i
        @upcoming_challenge.start_date =  @edit_challenge.end_date.strftime("%Y-%m-%d").to_date + 1.day
        @upcoming_challenge.end_date = @edit_challenge.end_date.strftime("%Y-%m-%d").to_date + (difference +1).day
        @upcoming_challenge.save
      end
      respond_to do |format|
        format.js {render "/layouts/flash", locals: { title: 'Congratulations !!', message: 'Challenge was successfully updated.', redirect_to: root_url }}
      end
    else
      respond_to do |format|
        format.js {render "/layouts/errors", locals: { full_errors: @edit_challenge.errors.full_messages }}
      end
    end
  end

  def destroy
    @challenge.destroy
    respond_to do |format|
      format.js {render "/layouts/flash", locals: { title: 'Congratulations !!', message: 'Challenge was successfully destroyed.', redirect_to: challenges_url }}
    end
  end

  def get_ballyhoo_form
    @ballyhoo = ballyhoo_type_class.new
    respond_to do | format |
      format.js {render '/ballyhoos/get_ballyhoo_form'}
    end
  end

  def ballyhoo_type_class
    ballyhoo_type.constantize
  end

  def ballyhoo_type
    params[:type] || "Ballyhoo"
  end
  
  def set_end_date
    unless params[:challenge][:start_date].blank? || params[:challenge][:duration].blank?
      params[:challenge][:start_date].to_date + params[:challenge][:duration].to_i.days
    end
  end
  
  def populate_loyal_patrons
    @loyal_patrons = current_establishment.loyal_patrons
  end
  
  def determine_payout
    @payouts = @active_challenges.calculate_current_payouts(@active_challenges.participants.to_i).to_a
  end
  
  private
  def populate_form(new = true)
    @all_upcoming_challenges = []
    current_establishment.challenges.each do |challenge|
      if challenge.active?
        @active_challenges = challenge
        @active_challenges.gross_sales ||= 0
        @active_challenges.participants ||= 0
      elsif challenge.upcoming?
        @all_upcoming_challenges << challenge
      end
    end
    if @active_challenges.present?
      difference = (@active_challenges.end_date.to_date - @active_challenges.start_date.to_date).to_i + 1
      upcoming_challenge = current_establishment.challenges.new( challenge_winner: @active_challenges.challenge_winner,
        challenge_prize: @active_challenges.challenge_prize,
        win_differential: @active_challenges.win_differential,
        payout: @active_challenges.payout,
        duration: difference,
        repeat: @active_challenges.repeat,
        linked_with: @active_challenges.id
      )
      difference = (@active_challenges.end_date.to_date - @active_challenges.start_date.to_date).to_i
      upcoming_challenge.start_date =  @active_challenges.end_date.strftime("%Y-%m-%d").to_date + 1.day
      upcoming_challenge.end_date = @active_challenges.end_date.strftime("%Y-%m-%d").to_date + (difference +1).day
    end

    @upcoming_challenges =  @all_upcoming_challenges.sort_by(&:start_date).first
    # @all_ballyhoos = current_establishment.ballyhoos.all
    @all_ballyhoos = current_establishment.ballyhoos.order(sort_column + " " + sort_direction)
    if params[:sort].present?
      session[:booster] = true
    end
    
    if @upcoming_challenges.nil? && !upcoming_challenge.nil?
      upcoming_challenge.save
      if upcoming_challenge.save
        @challenge = upcoming_challenge
        @upcoming_challenges = upcoming_challenge
      else
        @challenge = Challenge.new
      end
    elsif @upcoming_challenge.nil? && upcoming_challenge.nil?
      @challenge = Challenge.new
    else
      @challenge = @upcoming_challenges
    end
    @ballyhoo = Ballyhoo.new
  end

  def set_challenge
    @challenge = current_establishment.challenges.find(params[:id])
  end

  def challenge_params
    unless set_end_date.nil?
      params[:challenge][:end_date] = set_end_date - 1.day
    end
    params.require(:challenge).permit(:start_date, :end_date, :payout, :finish_points, :friend_bonus, :friend_limit, :challenge_prize, :challenge_winner, :win_differential,:participants,:gross_sales,:repeat,:duration)
  end

  def sort_column
    Ballyhoo.column_names.include?(params[:sort]) ? params[:sort] : "ballyhoo_type"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end
end
