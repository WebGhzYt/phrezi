class CreateEnrolledChallenges < ActiveRecord::Migration
  def change
    create_table :enrolled_challenges do |t|
      t.references :challenge, index: true
      t.integer :patron_id
      t.integer :current_points

      t.timestamps
    end
  end
end
