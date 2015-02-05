class CreateBoosterTransactions < ActiveRecord::Migration
  def change
    create_table :booster_transactions do |t|
      t.integer :points_scored
      t.references :ballyhoo
      t.references :challenge
      t.integer :establishment_id
      t.references :loyal_patron
      t.timestamps
    end
  end
end
