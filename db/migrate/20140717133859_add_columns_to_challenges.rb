class AddColumnsToChallenges < ActiveRecord::Migration
  def change
  	add_column :challenges, :challenge_prize, :decimal
  	add_column :challenges, :challenge_winner, :numeric
  	add_column :challenges, :win_differential, :decimal
  end
end
