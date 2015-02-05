class ChangeDefaultOfCurrentPointsInEnrolledChallenges < ActiveRecord::Migration
  def up
    change_column_default :enrolled_challenges, :current_points, 0
  end

  def down
    change_column_default :enrolled_challenges, :current_points, nil
  end
end
