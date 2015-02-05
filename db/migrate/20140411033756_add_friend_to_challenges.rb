class AddFriendToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :friend_bonus, :decimal
    add_column :challenges, :friend_limit, :integer
  end
end
