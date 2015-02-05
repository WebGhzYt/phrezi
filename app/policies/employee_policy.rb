class EmployeePolicy < Struct.new(:current_employee, :employee)
  def index?
    current_employee.administrator?
  end
  alias :show? :index?

  def create?
    employee.establishment_id == current_employee.establishment_id && index?
  end
  alias :update? :create?
  alias :destroy? :create?
end
