class ChangeColumnNameToBallyhoos < ActiveRecord::Migration
  def change
  	remove_column :ballyhoos, :include_friends
    add_column :ballyhoos, :audience, :integer
  end
end
