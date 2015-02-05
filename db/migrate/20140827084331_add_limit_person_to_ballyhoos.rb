class AddLimitPersonToBallyhoos < ActiveRecord::Migration
  def change
  	add_column :ballyhoos, :limit_person, :integer, default: 1
  end
end
