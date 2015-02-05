class AddAmountToBallyhoos < ActiveRecord::Migration
  def change
  	add_column :ballyhoos, :amount, :integer
  end
end
