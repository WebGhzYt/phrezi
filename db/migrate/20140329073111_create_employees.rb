class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :employee_role, default: 'server'
      t.references :user, index: true
      t.references :establishment, index: true
      t.boolean :enabled, default: true

      t.timestamps
    end
  end
end
