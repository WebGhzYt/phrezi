class CreatePurchaseTransactions < ActiveRecord::Migration
  def change
    create_table :purchase_transactions do |t|
      t.string :amount
      t.references :loyal_patron
      t.timestamps
    end
  end
end
