class CreateBallyhooTransactions < ActiveRecord::Migration
  def change
    create_table :ballyhoo_transactions do |t|
      t.integer :ballyhoo_id
      t.integer :challenge_id
      t.integer :user_id
      t.integer :point_amount
      t.timestamps
    end
  end
end
