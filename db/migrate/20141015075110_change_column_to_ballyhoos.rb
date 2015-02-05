class ChangeColumnToBallyhoos < ActiveRecord::Migration
  def change
  	change_column :ballyhoos, :total_checkin_qty, :string, default: ''
  end
end
