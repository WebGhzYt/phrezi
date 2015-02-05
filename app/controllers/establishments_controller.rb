class EstablishmentsController < WebApplicationController
  before_action :set_establishment, only: [ :edit, :update,:destroy, :set_current]
  skip_before_action :load_establishment, only: [:new, :create]

  def index
    @establishments = current_user.establishments.all
  end

  def new
    @establishment = Establishment.new
    @establishment.address = Address.new
    user_ids = current_user.id
    @users = User.where.not(id: user_ids)
    Date::DAYNAMES.each do |d|
      @establishment.establishment_hours.build day: d.downcase, open_time: '08:00', close_time: '22:00' #Time.parse('10:00pm')
    end
  end

  def edit
    gon.location = {lat: @establishment.gps_lat, lng: @establishment.gps_long}
    user_ids = current_establishment.employees.pluck(:user_id)
    @users = User.where.not(id: user_ids)
  end

  def create
    @establishment = Establishment.new(establishment_params)
    @employee = Employee.new(user: current_user, establishment: @establishment, role: 'administrator')
    
    if @establishment.save && @employee.save
      any_error = nil
      get_current
      @establishment.set_utc_time()
      # any_error = get_time_zone(@establishment)

      if params[:establishment][:picture].blank?
        # if current_user.establishments.count == 1
          if !any_error.blank? && any_error.to_s == "error"
            render :js => "alert('Establishment has saved but without timezone because address you have enter have no specific timezone.');document.location = '/challenges?setup=true'"
          else
            render :js => "document.location = '/challenges?setup=true'"
          end
        # else
        #   if !any_error.blank? && any_error.to_s == "error"
        #     render :js => "alert('Establishment has saved but without timezone because address you have enter have no specific timezone.');document.location = '/challenges'"
        #   else
        #     render :js => "document.location = '/challenges'"
        #   end
        # end
      else
        if !params[:establishment][:crop_x].blank? && !params[:establishment][:crop_y].blank? && !params[:establishment][:crop_w].blank? && !params[:establishment][:crop_h].blank?
          # if current_user.establishments.count == 1
            if !any_error.blank? && any_error.to_s == "error"
              render :js => "alert('Establishment has saved but without timezone because address you have enter have no specific timezone.');document.location = '/challenges?setup=true'"
            else
              render :js => "document.location = '/challenges?setup=true'"
            end
          # else
          #   if !any_error.blank? && any_error.to_s == "error"
          #     render :js => "alert('Establishment has saved but without timezone because address you have enter have no specific timezone.');document.location = '/challenges'"
          #   else
          #     render :js => "document.location = '/challenges'"
          #   end
          # end
        else
          respond_to do |format|
            if !any_error.blank? && any_error.to_s == "error"
              format.js {render :js => "alert('Establishment has saved but without timezone because address you have enter have no specific timezone.');document.location = '/challenges'"}
            else
              format.js { render "crop" }
            end
          end
        end
      end
    else
      gon.location = {lat: @establishment.gps_lat, lng: @establishment.gps_long}
      user_ids = @establishment.employees.pluck(:user_id)
      @users = User.where.not(id: user_ids)
      respond_to do |format|
        format.js {render "/layouts/errors", locals: { full_errors: @establishment.errors.full_messages }}
      end
    end
  end

  def update
    # authorize @establishment, :update?
    if @establishment.update(establishment_params)
      @establishment.set_utc_time()
      any_error = nil
      # any_error = get_time_zone(@establishment)
      
      if params[:establishment][:picture].blank?
        respond_to do |format|
          if !any_error.blank? && any_error.to_s == "error"
            format.js {render :js => "alert('Establishment has saved successfully, but without timezone because address you have enter have no specific timezone.');document.location = '/challenges'"}
          else
            format.js {render "/layouts/flash", locals: { title: 'Congratulations !!', message: 'Establishment was successfully updated.', redirect_to: root_url }}
          end
        end
      else
        if !params[:establishment][:crop_x].blank? && !params[:establishment][:crop_y].blank? && !params[:establishment][:crop_w].blank? && !params[:establishment][:crop_h].blank?
          respond_to do |format|
            if !any_error.blank? && any_error.to_s == "error"
              format.js {render :js => "alert('Establishment has saved but without timezone because address you have enter have no specific timezone.');document.location = '/challenges'"}
            else
              format.js {render "/layouts/flash", locals: { title: 'Congratulations !!', message: 'Establishment was successfully updated.', redirect_to: root_url }}
            end
          end
        else
          respond_to do |format|
            if !any_error.blank? && any_error.to_s == "error"
              format.js {render :js => "alert('Establishment has saved but without timezone because address you have enter have no specific timezone.');document.location = '/challenges'"}
            else
              format.js { render "crop" }
            end
          end
        end
      end
    else
      gon.location = {lat: @establishment.gps_lat, lng: @establishment.gps_long}
      user_ids = @establishment.employees.pluck(:user_id)
      @users = User.where.not(id: user_ids)
      #render action: 'edit'
      respond_to do |format|
        format.js {render "/layouts/errors", locals: { full_errors: @establishment.errors.full_messages , redirect_to: edit_establishment_path(current_establishment) }}
      end
    end
  end

  def get_time_zone(establishment)
    begin
      Timezone::Configure.begin do |c|
        c.username = 'faisalmalik_11'
        # c.username = 'phrenzi_app'
      end
      timezone = Timezone::Zone.new :latlon => [establishment.gps_lat, establishment.gps_long]
    
      if timezone.present?
        establishment.establishment_hours.each do |est_hours|
          open_time = timezone.time est_hours.open_time if est_hours.open_time.present?
          close_time = timezone.time est_hours.close_time if est_hours.close_time.present?
          est_hours.open_time = open_time if est_hours.open_time.present?
          est_hours.close_time = close_time if est_hours.close_time.present?
          est_hours.save!
        end
      end
    rescue
      return "error"
    end
  end

  def crop
    @establishment = Establishment.find(params[:id])
    @establishment.update_attributes(crop_params)
    @establishment.picture.reprocess!
    redirect_to root_path
  end

  def destroy
    authorize @establishment, :destroy?
    @establishment.destroy
    respond_to do |format|
      format.js {render "/layouts/flash", locals: { title: 'Congratulations !!', message: 'Establishment was successfully destroyed.', redirect_to: establishments_url }}
    end
    # redirect_to establishments_url, notice: 'Establishment was successfully destroyed.'
  end

  def set_current
    self.current_establishment = @establishment
    redirect_to :back
  end

  def get_current
    self.current_establishment = @establishment
  end

  def manualpurchase
    @enrolled_challenges = EnrolledChallenge.new
    @enrolled_ballyhoos = EnrolledChallenge.purchase_history
  end

  def create_manualpurchase
    @establishment = Establishment.find_by(id: params[:id])
    if @establishment.nil?
      flash[:notice] = "establishment not found."
      redirect_to root_path
    else
      all_active_ballyhoos = current_establishment.purchase_ballyhoos.select { |purchase_ballyhoo| purchase_ballyhoo.active? && (purchase_ballyhoo.start_time.strftime("%H:%M:%S") < Time.now.utc.strftime("%H:%M:%S") && purchase_ballyhoo.end_time.strftime("%H:%M:%S") > Time.now.utc.strftime("%H:%M:%S"))}
      extra_points = 0
      if all_active_ballyhoos.empty?
        # Do nothing
      else
        active_ballyhoo = all_active_ballyhoos.sample
        ballyhoo_transaction = BallyhooTransaction.new(ballyhoo_id: active_ballyhoo.id,
          user_id: params[:enrolled_challenge][:patron_id],
          point_amount: active_ballyhoo.point_value
        )
        extra_points = ballyhoo_transaction.point_amount
      end
      standard_points = params[:enrolled_challenge][:amount].to_i
      total_points = standard_points + extra_points

      patron_enrolled_challenge = EnrolledChallenge.find_by(patron_id: params[:enrolled_challenge][:patron_id])
      if patron_enrolled_challenge.nil?
        @enrolled_challenges = EnrolledChallenge.new(patron_id: params[:enrolled_challenge][:patron_id],
          current_points: total_points)
        @enrolled_challenges.amount = params[:enrolled_challenge][:amount]
      else
        @enrolled_challenges = patron_enrolled_challenge
        @enrolled_challenges.current_points = patron_enrolled_challenge.current_points + total_points
        @enrolled_challenges.amount = params[:enrolled_challenge][:amount]
      end
      if @enrolled_challenges.save
        ballyhoo_transaction.save!
        redirect_to manualpurchase_establishment_path(current_establishment.id)
        flash[:notice] = "Purchase successfully added."
      else
        @enrolled_ballyhoos = EnrolledChallenge.purchase_history
        render :manualpurchase
      end
    end
  end


  def check_map_position
    respond_to do |format|
      format.js {render "/layouts/map_error", locals: { title: 'Alert !!' , message: params[:message] }}
    end
  end

  private
  def set_establishment
    if current_user.has_establishment_access?
      @establishment = Establishment.find(params[:id])
    else
      @establishment = current_user.establishments.find(params[:establishment_id] ||= params[:id])
    end
  end

  def crop_params
    params.require(:establishment).permit(:crop_x, :crop_y, :crop_w, :crop_h)
  end

  def establishment_params
    params.require(:establishment).permit(
      :name,
      :address_id,
      :phone,
      :gps_lat,
      :gps_long,
      :website,
      :facebook,
      :twitter,
      :group_id,
      :point_dollar,
      :default_currency,
      :picture,
      address_attributes: [
        :street1,
        :street2,
        :city,
        :state,
        :country,
        :postal,
        :id
      ],
      establishment_hours_attributes: [
        :id,
        :day,
        :open_time,
        :close_time,
        :closed
      ],
      menu_items_attributes: [
        :id,
        :name,
        :category,
        :price
      ],
      employees_attributes: [
        :id,
        :user_id,
        :role
      ]
    )
  end
end
