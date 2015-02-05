class AddRepeatToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :repeat, :boolean , default: false
  end
end
