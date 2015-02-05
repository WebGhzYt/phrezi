class SymbolPolicy < Struct.new(:current_employee, :symbol)
  def index?
    permissions = {
      establishment: lambda { true },
      employee: lambda { current_employee.owner? },
      challenge: lambda { current_employee.owner? || current_employee.manager? },
      checkin_ballyhoo: lambda { current_employee.owner? || current_employee.manager? }
    }
    permissions[symbol].call
  end
end
