class AddCheckInMethodToBallyhoo < ActiveRecord::Migration
  def change
  	add_column :ballyhoos, :method, :string
  end
end
