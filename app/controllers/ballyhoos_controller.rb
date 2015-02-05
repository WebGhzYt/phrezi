class BallyhoosController < WebApplicationController
  before_action :set_ballyhoo, only: [:show, :edit, :update, :destroy]
  before_action :set_ballyhoo_type
  
  def index
    @ballyhoos = {
      :active => [],
      :upcoming => [],
      :paused => [],
      :archived => [],
      :uncategorized => []
    }
    ballyhoo_type_class.all.each do |bally|
      if bally.active?
        @ballyhoos[:active] << bally
      elsif bally.upcoming?
        @ballyhoos[:upcoming] << bally
      elsif bally.paused?
        @ballyhoos[:paused] << bally
      elsif bally.archived?
        @ballyhoos[:archived] << bally
      else
        @ballyhoos[:uncategorized] << bally
      end
    end
  end

  def show
  end

  def new
    if params[:ballyhoo_id]
      @copied_ballyhoo = Ballyhoo.find_by(id: params[:ballyhoo_id])
      unless @copied_ballyhoo.nil?
        @copied_ballyhoo.end_repeat = ''
      end
    end
    @ballyhoo = ballyhoo_type_class.new
  end

  def edit
    #render :partial => "ballyhoos/boosters/boosters_setup"
    respond_to do |format|
      format.js
      format.html
    end 
  end

  def create
    @ballyhoo = current_establishment.ballyhoos.new(ballyhoo_params)
    # if @ballyhoo.audience == '1'
    #   @ballyhoo.include_friends = true
    # else
    #   @ballyhoo.include_friends = false
    # end
    if params[:repeat_type].present?
      @ballyhoo.repeat_type = 1
    else
      @ballyhoo.repeat_type = 0
    end
    if params[:quantity_available].present?
      @ballyhoo.total_checkin_qty = 'Unlimited'
    else
      @ballyhoo.total_checkin_qty = params[:total_checkin_qty]
    end
    if @ballyhoo.ballyhoo_type == 'PurchaseBallyhoo'
      if params[:item_type] == "product"
        @ballyhoo.product_category = params[:product]
        @ballyhoo.point_multiplier = params[:point_multiplier]
        @ballyhoo.point_addition = nil
      elsif params[:item_type] == "category"
        @ballyhoo.product_category = params[:category]
        @ballyhoo.point_multiplier = nil
        @ballyhoo.point_addition = params[:point_addition]
      end
    end
    unless @ballyhoo.ballyhoo_type == 'PurchaseBallyhoo'
      @ballyhoo.purchase_amount = ''
      @ballyhoo.min_no_of_item = ''
      @ballyhoo.category_id = ''
      @ballyhoo.product_category = ''
    end
    if @ballyhoo.save
      session[:booster] = true
      respond_to do |format|
        format.js {render "/layouts/flash", locals: { title: 'Congratulations !!', message: 'Booster was successfully created.', redirect_to: root_url }}
      end
    else
      session[:booster] = true
      respond_to do |format|
        format.js {render "/layouts/errors", locals: { full_errors: @ballyhoo.errors.full_messages }}
      end
    end
  end

  def update
    @ballyhoo = ballyhoo_type_class.find(params[:id])
    # if ballyhoo_params[:audience] == '1'
    #   @ballyhoo.include_friends = true
    # else
    #   @ballyhoo.include_friends = false
    # end
    if params[:repeat_type].present?
      @ballyhoo.repeat_type = 1
    else
      @ballyhoo.repeat_type = 0
    end
    if params[:quantity_available].present?
      @ballyhoo.total_checkin_qty = 'Unlimited'
    else
      @ballyhoo.total_checkin_qty = params[:total_checkin_qty]
    end
    if @ballyhoo.ballyhoo_type == 'PurchaseBallyhoo'
      if params[:item_type] == "product"
        @ballyhoo.product_category = params[:product]
        @ballyhoo.point_multiplier = params[:point_multiplier]
        @ballyhoo.point_addition = nil
      elsif params[:item_type] == "category"
        @ballyhoo.product_category = params[:category]
        @ballyhoo.point_multiplier = nil
        @ballyhoo.point_addition = params[:point_addition]
      end
    end
    unless @ballyhoo.ballyhoo_type == 'PurchaseBallyhoo'
      @ballyhoo.purchase_amount = ''
      @ballyhoo.min_no_of_item = ''
      @ballyhoo.category_id = ''
      @ballyhoo.product_category = ''
    end
    if @ballyhoo.update(ballyhoo_params)
      session[:booster] = true
      respond_to do |format|
        format.js {render "/layouts/flash", locals: { title: 'Congratulations !!', message: 'Booster was successfully updated.', redirect_to: root_url }}
      end
    else
      session[:booster] = true
      respond_to do |format|
        format.js {render "/layouts/errors", locals: { full_errors: @ballyhoo.errors.full_messages }}
      end
    end
  end

  def destroy
    @ballyhoo.destroy
    session[:booster] = true
    respond_to do |format|
      format.js {render "/layouts/flash", locals: { title: 'Congratulations !!', message: 'Booster was successfully destroyed.', redirect_to: root_url }}
    end
  end

  def show_active_boosters
    date = DateTime.parse(params[:date])
    @ballyhoos = []
    #current_establishment.ballyhoos.where("enabled = ? AND start_date <= ? AND end_repeat >= ?",true, date,date)
    current_establishment.ballyhoos.each do |ballyhoo|
      if ballyhoo.end_repeat
        if ballyhoo.start_date <= date and ballyhoo.end_repeat >= date and ballyhoo.enabled
          @ballyhoos << ballyhoo
        end
      elsif ballyhoo.start_date <= date and ballyhoo.enabled
        @ballyhoos << ballyhoo
      end
    end
    render :partial => "ballyhoos/boosters/active_boosters"
  end

  def change_status
    session[:booster] = true
    @ballyhoos = ballyhoo_type_class.find_by(id: params[:id])
    if @ballyhoos.enabled
      @ballyhoos.enabled = false
    else
      @ballyhoos.enabled = true
    end
    if @ballyhoos.save!
      redirect_to root_path
    end
  end

  def manual
    @manual_checkin = Checkin.new
    @currently_checkin_ballyhoo = Checkin.currently_checkin_user
  end

  def manual_checkin
    if params[:user_id] == ""
      flash[:alert] = "Please select a patron."
    else
      @manual_checkin = Checkin.current_checkin(params[:user_id]).first
      if @manual_checkin.nil?
        @manual_checkin = Checkin.new(:start_time => Time.now,
          :establishment_id => current_establishment.id,
          :user_id => params[:user_id]
        )
        if @manual_checkin.save
          flash[:notice] = "Successfully checkin."
          active_ballyhoos = current_establishment.checkin_ballyhoos.select { |checkin_ballyhoo| checkin_ballyhoo.active? && (checkin_ballyhoo.start_time.strftime("%H:%M:%S") < Time.now.utc.strftime("%H:%M:%S") && checkin_ballyhoo.end_time.strftime("%H:%M:%S") > Time.now.utc.strftime("%H:%M:%S"))}
          unless active_ballyhoos.empty?
            ballyhoo_transaction = BallyhooTransaction.create(:ballyhoo_id => active_ballyhoos.sample.id,
              :user_id => params[:user_id],
              :point_amount => active_ballyhoos.sample.point_value
            )
            enrolled_user = EnrolledChallenge.find_by(patron_id: params[:user_id])
            if enrolled_user.nil?
              enrolled_points = EnrolledChallenge.create(:patron_id => params[:user_id],
                :current_points => active_ballyhoos.sample.point_value)
            else
              enrolled_user.update_attributes(current_points: enrolled_user.current_points + active_ballyhoos.sample.point_value)
            end
          end
        else
          flash[:notice] = "There might be some error. Try again."
        end
      else
        flash[:notice] = "Already checkin."
      end
    end
    render text: true
  end

  def manual_checkout
    if params[:user_id] == ""
      flash[:alert] = "Please select a patron."
    else
      manual_checkout = Checkin.current_checkin(params[:user_id]).first
      if manual_checkout.nil?
        flash[:notice] = "Please checkin first."
      else
        @manual_checkout = Checkin.current_checkin(params[:user_id]).first
        .update_attributes(end_time: Time.now)
        if true
          flash[:notice] = "Successfully checkout."
        else
          flash[:notice] = "There might be some error. Try again."
        end
      end
    end
    render text: true
  end
  
  def set_ballyhoo_type
    @ballyhoo_type = ballyhoo_type
  end

  def ballyhoo_type
    params[:type] || "Ballyhoo"
  end

  def ballyhoo_type_class
    ballyhoo_type.constantize
  end

  def set_ballyhoo
    @ballyhoo = ballyhoo_type_class.find(params[:id])
  end

  def all_boosters
    @all_boosters = current_establishment.ballyhoos.all
    respond_to do |format|
      format.html
      format.json { render :json => @all_boosters.as_json(:calendar => true)}
    end
  end

  def ballyhoo_params

    params.require(ballyhoo_type.underscore.to_sym).permit(:title, :description, :start_date,
      :ballyhoo_all_day, :start_time,
      :end_time, :repeat_type,
      :end_repeat, :ballyhoo_type,
      :point_value, :audience,
      :total_checkin_qty,
      :friends, :limit_person,
      :category_id, :min_no_of_item,
      :purchase_amount,:all_day,
      :repeating_days,:point_multiplier,
      :product_category, :point_addition)
  end
end
