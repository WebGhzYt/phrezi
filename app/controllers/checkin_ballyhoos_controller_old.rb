class CheckinBallyhoosControllerOLD < WebApplicationController
  before_action :set_checkin_ballyhoo, only: [:show, :edit, :update, :destroy]

  # GET /checkin_ballyhoos
  def index
    @checkin_ballyhoos = current_establishment.checkin_ballyhoos
  end

  # GET /checkin_ballyhoos/1
  def show
  end

  # GET /checkin_ballyhoos/new
  def new
    @checkin_ballyhoo = current_establishment.checkin_ballyhoos.new(
      ballyhoo_date: Time.zone.now + 1.day
    )
  end

  # GET /checkin_ballyhoos/1/edit
  def edit
    @checkin_ballyhoo.populate_transient_fields
  end

  # POST /checkin_ballyhoos
  def create
    #need to parse the form parameters to create the appropriate model properties

    @checkin_ballyhoo = current_establishment.checkin_ballyhoos.new(checkin_ballyhoo_params)
    @checkin_ballyhoo.ballyhoo_date = Time.zone.parse(@checkin_ballyhoo.ballyhoo_date)
    @checkin_ballyhoo.ballyhoo_start = @checkin_ballyhoo.ballyhoo_start_time.change(
      year: @checkin_ballyhoo.ballyhoo_date.year,
      month: @checkin_ballyhoo.ballyhoo_date.month,
      day: @checkin_ballyhoo.ballyhoo_start_time.day)
    @checkin_ballyhoo.ballyhoo_end = @checkin_ballyhoo.ballyhoo_end_time.change(
      year: @checkin_ballyhoo.ballyhoo_end_time.year,
      month: @checkin_ballyhoo.ballyhoo_end_time.month,
      day: @checkin_ballyhoo.ballyhoo_end_time.day)

    if @checkin_ballyhoo.save
      redirect_to @checkin_ballyhoo, notice: 'Checkin ballyhoo was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /checkin_ballyhoos/1
  def update
    @checkin_ballyhoo.assign_attributes(checkin_ballyhoo_params)
    @checkin_ballyhoo.ballyhoo_date = Time.zone.parse(@checkin_ballyhoo.ballyhoo_date)
    @checkin_ballyhoo.ballyhoo_start = @checkin_ballyhoo.ballyhoo_start_time.change(
      year: @checkin_ballyhoo.ballyhoo_date.year,
      month: @checkin_ballyhoo.ballyhoo_date.month,
      day: @checkin_ballyhoo.ballyhoo_start_time.day)
    @checkin_ballyhoo.ballyhoo_end = @checkin_ballyhoo.ballyhoo_end_time.change(
      year: @checkin_ballyhoo.ballyhoo_end_time.year,
      month: @checkin_ballyhoo.ballyhoo_end_time.month,
      day: @checkin_ballyhoo.ballyhoo_end_time.day)

    if @checkin_ballyhoo.save
      redirect_to @checkin_ballyhoo, notice: 'Checkin ballyhoo was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /checkin_ballyhoos/1
  def destroy
    @checkin_ballyhoo.destroy
    redirect_to checkin_ballyhoos_url, notice: 'Checkin ballyhoo was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_checkin_ballyhoo
      @checkin_ballyhoo = current_establishment.checkin_ballyhoos.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def checkin_ballyhoo_params
      params.require(:checkin_ballyhoo).permit(:include_friends, :total_checkin_qty, :point_value, :ballyhoo_start_time, :ballyhoo_end_time, :ballyhoo_date, :ballyhoo_all_day, :repeat_type, :end_repeat)
    end
end
