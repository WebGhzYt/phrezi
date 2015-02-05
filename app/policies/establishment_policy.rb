class EstablishmentPolicy < Struct.new(:employee, :establishment)
  def index?
    true
  end
  alias :show? :index?

  def create?
    true
  end

  def update?
    employee.user.employee_for(establishment).try(:owner?)
  end

  def destroy?
    employee.user.employee_for(establishment).try(:owner?)
  end
end
