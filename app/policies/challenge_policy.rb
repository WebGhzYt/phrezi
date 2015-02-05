class ChallengePolicy < Struct.new(:current_employee, :challenge)
  def index?
    current_employee.manager? || current_employee.owner?
  end
  alias :show? :index?

  def create?
    (challenge.establishment_id == current_employee.establishment_id) && index?
  end
  alias :update? :create?
  alias :destroy? :create?
end
