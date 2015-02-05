class AddPurchaseTypeToCheckinBallyhoo < ActiveRecord::Migration
  def change
    add_column :checkin_ballyhoos, :repeat_type, :integer, default: 0
  end
end
