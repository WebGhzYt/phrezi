class UpdateChallengeWinnersToDecimal < ActiveRecord::Migration
  def up
    change_table :challenges do |t|
      t.change :challenge_winner, :decimal
    end
  end
 
  def down
    change_table :challenges do |t|
      t.change :challenge_winner, :numeric
    end
  end
end
