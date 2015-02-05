class ChangeEmployeeRoleToInteger < ActiveRecord::Migration
  def up
    remove_column :employees, :employee_role
    add_column :employees, :role, :integer, default: 0
  end

  def down
    remove_column :employees, :role
    add_column :employees, :employee_role, :string, default: 'server'
  end
end
