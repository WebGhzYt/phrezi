class AddColumnUserIdToBallyhoo < ActiveRecord::Migration
  def change
  	add_column :ballyhoos, :user_id, :integer
  end
end
