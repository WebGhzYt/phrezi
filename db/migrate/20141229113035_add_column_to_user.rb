class AddColumnToUser < ActiveRecord::Migration
  def change
  	add_column :users, :establishment_access, :boolean, default: false
  end
end
