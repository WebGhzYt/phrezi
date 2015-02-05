class EnrolledChallengesController < WebApplicationController
  before_action :set_challenge
  before_action :set_enrolled_challenge, only: [:show, :edit, :update, :destroy]

  def index
    @enrolled_challenges = @challenge.enrolled_challenges
  end

  def show
  end

  def new
    @enrolled_challenge = @challenge.enrolled_challenges.build
  end

  def edit
  end

  def create
    @enrolled_challenge = @challenge.enrolled_challenges.build(enrolled_challenge_params)

    if @enrolled_challenge.save
      redirect_to [@challenge, @enrolled_challenge], notice: 'Enrolled challenge was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @enrolled_challenge.update(enrolled_challenge_params)
      redirect_to [@challenge, @enrolled_challenge], notice: 'Enrolled challenge was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @enrolled_challenge.destroy
    redirect_to challenge_enrolled_challenges_url(@challenge), notice: 'Enrolled challenge was successfully destroyed.'
  end

  private
    def set_enrolled_challenge
      @enrolled_challenge = @challenge.enrolled_challenges.find(params[:id])
    end

    def set_challenge
      @challenge = current_establishment.challenges.find(params[:challenge_id])
    end

    def enrolled_challenge_params
      params.require(:enrolled_challenge).permit(:patron_id, :current_points)
    end
end
