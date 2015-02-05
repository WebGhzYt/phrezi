class CheckinBallyhooPolicy < Struct.new(:current_employee, :checkin_ballyhoo)
  def index?
    current_employee.manager? || current_employee.owner?
  end
  alias :show? :index?

  def create?
    checkin_ballyhoo.establishment_id == current_employee.establishment_id && index?
  end
  alias :update? :create?
  alias :destroy? :create?
end
