class AddPointMutliplierToBallyhoos < ActiveRecord::Migration
  def change
    add_column :ballyhoos, :point_multiplier, :integer
  end
end
