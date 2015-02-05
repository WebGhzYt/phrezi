class AddUserIdToCheckinBallyhoos < ActiveRecord::Migration
  def change
  	add_column :checkin_ballyhoos, :user_id, :integer
  end
end
