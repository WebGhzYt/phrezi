class AddGrossSalesToChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :gross_sales, :decimal, precision: 11, scale: 2, default: 0
    remove_column :challenges, :finish_points
    remove_column :challenges, :friend_bonus
    remove_column :challenges, :friend_limit
  end
end
