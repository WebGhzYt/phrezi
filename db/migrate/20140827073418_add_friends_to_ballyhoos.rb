class AddFriendsToBallyhoos < ActiveRecord::Migration
  def change
  	add_column :ballyhoos, :friends, :integer
  end
end
