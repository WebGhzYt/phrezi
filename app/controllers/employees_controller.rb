class EmployeesController < WebApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]

  # GET /employees
  def index
    authorize current_employee, :index?
    @employees = current_establishment.employees.all
  end

  # GET /employees/1
  def show
  end

  # GET /employees/new
  def new
    @employee = current_establishment.employees.build
    populate_form
    authorize @employee, :create?
  end

  # GET /employees/1/edit
  def edit
    authorize @employee, :update?
  end

  # POST /employees
  def create
    @employee = current_establishment.employees.build(create_employee_params)
    authorize @employee, :create?
    invited_user = invite_employee
    if invited_user
      if @employee.save
        @employee.update_attribute(:user_id, invited_user.id)
        #        flash[:notice]="Your invite has been dispatched."
        #redirect_to root_path(:msg => "true")
        respond_to do |format|
          format.js {render "/layouts/flash", locals: { title: 'Congratulations !!', message: 'Your invite has been dispatched.', redirect_to: challenges_url }}
        end
      else
        #flash[:notice]="#{@employee.errors.full_messages.join(', ')}"
        #redirect_to root_path
        respond_to do |format|
          format.js {render "/layouts/errors", locals: { full_errors: @employee.errors.full_messages }}
        end
      end
    else
      #      flash[:notice]="The employee has been added."
      #redirect_to root_path(:msg => "false")
      respond_to do |format|
        format.js {render "/layouts/flash", locals: { title: 'Congratulations !!', message: 'The employee has been added.', redirect_to: challenges_url }}
      end
      
    end
  end

  # PATCH/PUT /employees/1
  def update
    authorize @employee, :update?
    if @employee.update(update_employee_params)
      redirect_to @employee, notice: 'Employee was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /employees/1
  def destroy
    #authorize @employee, :destroy?
    if @employee.destroy
      respond_to do |format|
        format.js {render "/layouts/flash", locals: { title: 'Congratulations !!', message: 'Employee successfully deleted.', redirect_to: challenges_url }}
      end
    end
  end
  
  def invite_employee
    user = User.invite!(email: params[:email])
    
    employee = Employee.where(:user_id => user.id, :establishment_id => current_establishment.id).first

    if employee.blank?
      return user
    else
      return false
    end
  end
  
  private

  def populate_form
    user_ids = current_establishment.employees.pluck(:user_id)
    @users = User.where.not(id: user_ids)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_employee
    @employee = current_establishment.employees.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def update_employee_params
    params.require(:employee).permit(:role, :enabled)
  end

  def create_employee_params
    params.require(:employee).permit(:role, :user_id)
  end
end
