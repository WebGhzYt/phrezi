class AddColumnToBallyhoos < ActiveRecord::Migration
  def change
  	add_column :ballyhoos, :point_addition, :integer
  end
end
