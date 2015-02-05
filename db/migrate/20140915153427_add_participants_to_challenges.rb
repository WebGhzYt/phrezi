class AddParticipantsToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :participants, :string
  end
end
