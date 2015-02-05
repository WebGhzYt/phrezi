class AddRepeatingDaysToBallyhoos < ActiveRecord::Migration
  def change
    add_column :ballyhoos, :repeating_days, :text
  end
end
