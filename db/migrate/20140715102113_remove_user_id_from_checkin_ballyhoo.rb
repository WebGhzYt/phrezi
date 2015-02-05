class RemoveUserIdFromCheckinBallyhoo < ActiveRecord::Migration
  def change
  	remove_column :checkin_ballyhoos, :user_id
  end
end
