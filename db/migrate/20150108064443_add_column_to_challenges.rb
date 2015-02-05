class AddColumnToChallenges < ActiveRecord::Migration
  def change
  	add_column :challenges, :linked_with, :integer
  end
end
