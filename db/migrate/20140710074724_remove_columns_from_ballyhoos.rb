class RemoveColumnsFromBallyhoos < ActiveRecord::Migration
  def change
  	remove_column :ballyhoos, :method
  	remove_column :ballyhoos, :user_id
  	remove_column :ballyhoos, :amount
  end
end
