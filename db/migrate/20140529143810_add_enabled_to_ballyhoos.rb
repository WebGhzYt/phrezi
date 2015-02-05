class AddEnabledToBallyhoos < ActiveRecord::Migration
  def change
  	add_column :ballyhoos, :enabled, :boolean, default: true
  end
end
