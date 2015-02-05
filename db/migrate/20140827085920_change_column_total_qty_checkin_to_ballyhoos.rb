class ChangeColumnTotalQtyCheckinToBallyhoos < ActiveRecord::Migration
  def change
  	change_column :ballyhoos, :total_checkin_qty, :string, default: 'Unlimited'
  end
end
