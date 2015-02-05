class AddAllDayToBallyhoos < ActiveRecord::Migration
  def change
    add_column :ballyhoos, :all_day, :boolean,:default => false
  end
end
