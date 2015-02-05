class Employee < ActiveRecord::Base
  belongs_to :user
  belongs_to :establishment

  enum role: [:server, :manager, :administrator]
  

  class << self
    def emp_roles
      [['Server','server'], ['Manager', 'manager']]
    end
  end
end
