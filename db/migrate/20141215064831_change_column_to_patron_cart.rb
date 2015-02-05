class ChangeColumnToPatronCart < ActiveRecord::Migration
  def change
    remove_column :patron_carts, :booster_id
    remove_column :patron_carts, :quantity
    rename_column :patron_carts, :total, :purchase_total
    change_column :patron_carts, :purchase_total, :decimal
    add_column :patron_carts, :establishment_id, :integer
  end
end
